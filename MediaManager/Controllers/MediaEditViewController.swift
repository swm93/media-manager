//
//  MediaEditViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-01.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class MediaEditViewController : UIViewController
{
    @IBOutlet public var titleTextField:UITextField!
    @IBOutlet public var imageView:UIImageView!
    @IBOutlet public var tableViewContainer:UIView!
    
    public var mediaType:MediaType!
    public var managedObject:(ManagedObject & Media)?
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // create managed object if one doesn't exist
        if (self.managedObject == nil)
        {
            self.managedObject = self.createMedia(self.mediaType)
        }
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        // setup media image
        imageView.image = mediaType?.defaultImage
        
        // setup table view
        var tableViewController:MediaEditTableViewController?
        
        switch(self.mediaType)
        {
        case .some(.book):
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookEditTableViewController") as! BookEditTableViewController
            break
            
        case .some(.game):
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "GameEditTableViewController") as! GameEditTableViewController
            break
            
        case .some(.movie):
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MovieEditTableViewController") as! MovieEditTableViewController
            break
            
        case .some(.music):
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MusicEditTableViewController") as! MusicEditTableViewController
            break
            
        case .some(.show):
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShowEditTableViewController") as! ShowEditTableViewController
            break
            
        case .none:
            tableViewController = nil
            break
        }

        
        tableViewController?.mediaObject = managedObject

        if let controller:MediaEditTableViewController = tableViewController
        {
            addChildViewController(controller)
            self.tableViewContainer.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "SearchSegue")
        {
            let destinationVC:SearchViewController = segue.destination as! SearchViewController
            
            destinationVC.delegate = self
            
            if let query:String = titleTextField.text
            {
                destinationVC.search(query)
            }
        }
    }
    
    
    @IBAction func save()
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        
        do
        {
            try managedContext.save()
            dismiss(animated: true)
        }
        catch let error
        {
            print("Could not save \(error)")
        }
    }
    
    
    @IBAction func cancel()
    {
        dismiss(animated: true)
    }
    
    
    @IBAction func nameTextFieldChanged()
    {
        managedObject?.name = titleTextField.text
    }
    
    
    private func createMedia(_ mediaType:MediaType) -> ManagedObject & Media
    {
        var managedObject:ManagedObject & Media
        
        switch (mediaType)
        {
        case .book:
            managedObject = BookManaged()
            break
            
        case .game:
            managedObject = GameManaged()
            break
            
        case .movie:
            managedObject = MovieManaged()
            break
            
        case .music:
            managedObject = SongManaged()
            break
            
        case .show:
            managedObject = ShowManaged()
            break
        }
        
        return managedObject
    }
}



extension MediaEditViewController : ParserDelegate
{
    func getParseResultObject<T>() -> T?
    {
        if let managedObject:T = self.managedObject as? T
        {
            return managedObject
        }
        
        return nil
    }
}



extension MediaEditViewController : SearchDelegate
{
    func fetchSearchResults(_ query:String, completionHandler:@escaping ([SearchResult]?) -> Void)
    {
        if let type:MediaType = self.mediaType
        {
            var parser:APIParser<[SearchResult]>? = nil
            
            switch (type)
            {
            case .music:
                parser = LastFMSearchParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
                break
                
            case .game:
                parser = IGDBSearchParser(PListManager("Secrets")["igdb_api_key"] as! String)
                break
                
            default:
                break
            }
            
            if let p:APIParser<[SearchResult]> = parser
            {
                p.parse(["query": query], completionHandler: completionHandler)
            }
            else
            {
                let results:[SearchResult] = [SearchResult]()
                completionHandler(results)
            }
        }
    }
    
    
    func fetchDetailResult(_ searchResult:SearchResult, completionHandler:@escaping (ManagedObject?) -> Void)
    {
        if let type:MediaType = self.mediaType
        {
            var parser:APIParser<ManagedObject>?
            
            switch (type)
            {
            case .music:
                parser = LastFMDetailParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
                break
                
            default:
                parser = nil
                break
            }
            
            if let p:APIParser<ManagedObject> = parser
            {
                p.delegate = self
                p.parse(searchResult.detailParameters, completionHandler: completionHandler)
            }
            else
            {
                // TODO(scott): probably need to be able to pass nil to completetionHandler
            }
        }
    }
}
