//
//  SearchViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class SearchViewController: UIViewController
{
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var searchTableView:UITableView!
    
    public var mediaType: MediaType!
    
    internal var _selectedMedia: ManagedMedia?
    internal  var _debouncedSearch: (() -> ())!
    
    private var _searchParser: APIParser<[SearchResult]>!
    private var _detailParser: APIParser<ManagedMedia>!
    
    var searchResults:[SearchResult] = [SearchResult]()
    {
        didSet
        {
            DispatchQueue.main.async
            {
                self.searchTableView?.reloadData()
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self._debouncedSearch = debounce(interval: 400, queue: DispatchQueue.main, action: {
            self.fetchSearchResults(completionHandler: self.addSearchResults)
        })
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch (self.mediaType as MediaType)
        {
        case .music:
            self._searchParser = LastFMSearchParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
            self._detailParser = LastFMDetailParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
            break
            
        case .game:
            self._searchParser = IGDBSearchParser(PListManager("Secrets")["igdb_api_key"] as! String)
            self._detailParser = IGDBDetailParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
            break
            
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "MediaCreateSegue")
        {
            let destinationVC: MediaEditViewController = segue.destination as! MediaEditViewController
            destinationVC.mediaType = self.mediaType
            destinationVC.managedObject = self._selectedMedia ?? self.createMedia()
            
            self._selectedMedia = nil
        }
    }
    
    
    internal func fetchSearchResults(completionHandler: @escaping ([SearchResult]?) -> Void)
    {
        if let query: String = searchBar.text,
           let p: APIParser<[SearchResult]> = self._searchParser
        {
            p.parse(["query": query], completionHandler: completionHandler)
        }
    }
    
    
    internal func fetchDetailResult(_ searchResult: SearchResult, completionHandler: @escaping (ManagedMedia?) -> Void)
    {
        if let p: APIParser<ManagedMedia> = self._detailParser
        {
            p.delegate = self
            p.parse(searchResult.detailParameters, completionHandler: completionHandler)
        }
    }
    
    
    internal func createMedia() -> ManagedMedia
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        var managedObject:ManagedMedia
        
        switch (self.mediaType as MediaType)
        {
        case .book:
            managedObject = BookManaged(context: appDelegate.persistentContainer.viewContext)
            break
            
        case .game:
            managedObject = GameManaged(context: appDelegate.persistentContainer.viewContext)
            break
            
        case .movie:
            managedObject = MovieManaged(context: appDelegate.persistentContainer.viewContext)
            break
            
        case .music:
            managedObject = SongManaged(context: appDelegate.persistentContainer.viewContext)
            break
            
        case .show:
            managedObject = ShowManaged(context: appDelegate.persistentContainer.viewContext)
            break
        }
        
        managedObject.name = self.searchBar.text
        
        return managedObject
    }
    
    
    internal func addSearchResults(_ results:[SearchResult]?)
    {
        if let r:[SearchResult] = results
        {
            searchResults = r
        }
    }
    
    
    @IBAction func cancel()
    {
        dismiss(animated: true)
    }
}



extension SearchViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell
        if (indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewCell", for: indexPath)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
            let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
            let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
            let searchResult:SearchResult = searchResults[indexPath.row - 1]
            
            titleLabel.text = searchResult.primaryText
            subtitleLabel.text = searchResult.secondaryText
            imageView.image = searchResult.image
            
            imageView.layer.cornerRadius = imageView.frame.height / 2
            imageView.layer.masksToBounds = true
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // add one to searchResults count for "New" cell
        return searchResults.count + 1
    }
}



extension SearchViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.row != 0)
        {
            let searchResult:SearchResult = searchResults[indexPath.row - 1]
            
            self.fetchDetailResult(searchResult)
            { [weak self] (mediaManaged:ManagedMedia?) -> () in
                DispatchQueue.main.async
                {
                    self?._selectedMedia = mediaManaged
                    self?.performSegue(withIdentifier: "MediaCreateSegue", sender: self)
                }
            }
        }
    }
}



extension SearchViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text != nil)
        {
            self._debouncedSearch()
        }
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchResults.removeAll()
    }
}



extension SearchViewController : ParserDelegate
{
    func getParseResultObject<T>() -> T?
    {
        return self.createMedia() as? T
    }
}

