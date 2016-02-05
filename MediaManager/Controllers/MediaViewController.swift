//
//  SavedMediaViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-28.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class MediaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var mediaTable:UITableView!
    @IBOutlet weak var filterView:UIView!
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!

    
    var mediaObjects:[NSManagedObject] = [NSManagedObject]()
    {
        didSet
        {
            mediaTable.reloadData()
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest:NSFetchRequest = NSFetchRequest(entityName: "Artist")
        
        do
        {
            let results:[AnyObject] = try managedContext.executeFetchRequest(fetchRequest)
            mediaObjects = results as! [NSManagedObject]
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "MediaDetailSegue")
        {
            if let indexPath:NSIndexPath = mediaTable.indexPathForSelectedRow
            {
                let destinationVC:MediaDetailViewController = segue.destinationViewController as! MediaDetailViewController
                let mediaObject:Artist = Artist()
                mediaObject.name = mediaObjects[indexPath.row].valueForKey("name") as? String
                mediaObject.summary = mediaObjects[indexPath.row].valueForKey("summary") as? String
                mediaObject.genres = ((mediaObjects[indexPath.row].valueForKey("genres") as? String)?.componentsSeparatedByString(","))!
                mediaObject.image = UIImage(data: mediaObjects[indexPath.row].valueForKey("image") as! NSData)!
                
                destinationVC.mediaObject = mediaObject
            }
        }
    }
    
    
    @IBAction func toggleFilterView()
    {
        filterViewTopConstraint.constant = (filterViewTopConstraint.constant == 0.0) ? -filterView.frame.height : 0.0
        
        UIView.animateWithDuration(0.1)
        { [weak self] in
            self?.filterView.layoutIfNeeded()
            self?.mediaTable.layoutIfNeeded()
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        
        titleLabel.text = mediaObjects[indexPath.row].valueForKey("name") as? String
        subtitleLabel.text = mediaObjects[indexPath.row].valueForKey("genres") as? String
        imageView.image = UIImage(data: mediaObjects[indexPath.row].valueForKey("image") as! NSData)
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mediaObjects.count
    }
}