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
    
    public var mediaType:MediaType?
    
    internal var _managedObject:ManagedObject!
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        // setup media image
        imageView.image = mediaType?.defaultImage
        
        // setup table view
        var tableViewController:MediaEditTableViewController?
        
        switch(mediaType)
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

//        switch (self._managedObject)
//        {
//        case is BookManaged:
//            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookEditTableViewController") as! BookEditTableViewController
//            break
//            
//        case is GameManaged:
//            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "GameEditTableViewController") as! GameEditTableViewController
//            break
//            
//        case is MovieManaged:
//            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MovieEditTableViewController") as! MovieEditTableViewController
//            break
//            
//        case is ShowManaged:
//            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShowEditTableViewController") as! ShowEditTableViewController
//            break
//            
//        case is SongManaged:
//            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MusicEditTableViewController") as! MusicEditTableViewController
//            break
//            
//        default:
//            tableViewController = nil
//            break
//        }
        
        tableViewController?.mediaObject = _managedObject
//        _tableViewController = tableViewController
        
//        if let oldController:MediaEditTableViewController = oldValue
//        {
//            oldController.willMove(toParentViewController: nil)
//            oldController.view.removeFromSuperview()
//            oldController.removeFromParentViewController()
//        }
        
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
}



extension MediaEditViewController : SearchDelegate
{
    func fetchSearchResults(_ query:String, completionHandler:@escaping ([SearchResult]) -> Void)
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
    
    
    func fetchDetailResult(_ searchResult:SearchResult, completionHandler:@escaping (ManagedObject) -> Void)
    {
        if let type:MediaType = self.mediaType
        {
            var parser:APIParser<ManagedObject>? = nil
            
            switch (type)
            {
            case .music:
                parser = LastFMDetailParser(PListManager("Secrets")["audioscrobbler_api_key"] as! String)
                break
                
            default:
                break
            }
            
            if let p:APIParser<ManagedObject> = parser
            {
                p.parse(searchResult.detailParameters)
                { [weak self] (managedObject:ManagedObject) -> () in
                    self?._managedObject = managedObject
                    completionHandler(managedObject)
                }
            }
            else
            {
                // TODO(scott): probably need to be able to pass nil to completetionHandler
            }
        }
    }
}
