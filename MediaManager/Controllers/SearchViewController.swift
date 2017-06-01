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


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var searchTableView:UITableView!
    
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
    
    let searchParsers:[ParserType: APIParser<SearchResult>] = [
        .lastFM: LastFMSearchParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String),
        .igdb: IGDBSearchParser(PListManager("Secrets")["igdb_api_key"] as! String)
    ]
    
    let detailParsers:[ParserType: APIParser<ManagedObject>] = [
        .lastFM: LastFMDetailParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
    ]
    
    
    @IBAction func dismissViewController()
    {
        dismiss(animated: true) {}
    }
    
    
    func addSearchResults(_ results:[SearchResult])
    {
        searchResults += results
    }
    
    func downloadSearchResultDetail(_ searchResult:SearchResult, completionHandler:@escaping ([ManagedObject]) -> Void)
    {
        detailParsers[searchResult.parserType]?.parse([
            "query": searchResult.text
            ], completionHandler: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        let searchResult:SearchResult = searchResults[indexPath.row]
        
        titleLabel.text = searchResult.text
        subtitleLabel.text = searchResult.mediaType.name
        imageView.image = searchResult.image
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let searchResult:SearchResult = searchResults[indexPath.row]

        downloadSearchResultDetail(searchResult)
        { [weak self] (mediaManaged:[ManagedObject]) -> Void in
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
                
            do
            {
                try managedContext.save()
                self?.dismissViewController()
            }
            catch let error
            {
                print("Could not save \(error)")
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        if let query:String = textField.text
        {
            searchResults.removeAll()
            
            for (_, parser) in searchParsers
            {
                parser.parse([
                    "query": query
                    ], completionHandler: addSearchResults)
            }
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        searchResults.removeAll()
        
        return true
    }
}

