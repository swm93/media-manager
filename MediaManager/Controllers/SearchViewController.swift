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
    
    var mediaObjects:[Media] = [Media]()
    {
        didSet
        {
            dispatch_async(dispatch_get_main_queue())
            {
                self.searchTableView?.reloadData()
            }
        }
    }
    
    var lastFMParser:LastFMParser?
    var libraryThingParser:LibraryThingParser?
    var tvdbParser:TVDBParser?


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        lastFMParser = LastFMParser(completionHandler: addMediaObject)
        libraryThingParser = LibraryThingParser(completionHandler: addMediaObject)
        tvdbParser = TVDBParser(completionHandler: addMediaObject)
    }
    
    
    @IBAction func dismissViewController()
    {
        dismissViewControllerAnimated(true) {}
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
    
    func addMediaObject(mediaObject:Media?)
    {
        if let mediaObj:Media = mediaObject
        {
            mediaObjects.append(mediaObj)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        
        titleLabel.text = mediaObjects[indexPath.row].description
        subtitleLabel.text = mediaObjects[indexPath.row].secondaryText
        imageView.image = mediaObjects[indexPath.row].image
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let mediaObject:Artist = mediaObjects[indexPath.row] as? Artist
        {
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
            let entity:NSEntityDescription? =  NSEntityDescription.entityForName("Artist", inManagedObjectContext:managedContext)
            let artist:NSManagedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            artist.setValue(mediaObject.name, forKey: "name")
            artist.setValue(mediaObject.summary, forKey: "summary")
            artist.setValue(mediaObject.genres.joinWithSeparator(","), forKey: "genres")
            artist.setValue(UIImagePNGRepresentation(mediaObject.image), forKey: "image")
            
            do
            {
                try managedContext.save()
                dismissViewController()
            }
            catch let error as NSError
            {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        if let query:String = textField.text
        {
            mediaObjects.removeAll()
            
            lastFMParser?.parse([
                "api_key": "be3b35a76e9315d68bcbb13e3d5a704c",
                "query": query
            ])
            
//            tvdbParser.parse([
//                "api_key": "PUT_API_KEY_HERE",
//                "query": query
//            ])
//            
//            libraryThingParser.parse([
//                "api_key": "d57000b17ebbf55714fd7514b804fb9e",
//                "query": query
//            ])
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
        mediaObjects.removeAll()
        
        return true
    }
}

