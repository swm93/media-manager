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
    
    public var delegate:SearchDelegate?
    
    private var _currentQuery:String?
    
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
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let query:String = _currentQuery
        {
            searchBar.text = query
        }
    }
    
    
    func search(_ query:String)
    {
        _currentQuery = query
        
        searchResults.removeAll()
        
        self.delegate?.fetchSearchResults(query, completionHandler: addSearchResults)
    }
    
    
    @IBAction func cancel()
    {
        dismiss(animated: true)
    }
    
    
    internal func addSearchResults(_ results:[SearchResult]?)
    {
        if let r:[SearchResult] = results
        {
            searchResults += r
        }
    }
}



extension SearchViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        let searchResult:SearchResult = searchResults[indexPath.row]
        
        titleLabel.text = searchResult.primaryText
        subtitleLabel.text = searchResult.secondaryText
        imageView.image = searchResult.image
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
}



extension SearchViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let searchResult:SearchResult = searchResults[indexPath.row]
        
        self.delegate?.fetchDetailResult(searchResult)
        { [weak self] (mediaManaged:ManagedObject?) -> () in
            DispatchQueue.main.async
            {
                self?.dismiss(animated: true)
            }
        }
    }
}



extension SearchViewController : UISearchBarDelegate
{
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        if let query:String = searchBar.text
        {
            search(query)
        }
        
        searchBar.resignFirstResponder()
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchResults.removeAll()
    }
}

