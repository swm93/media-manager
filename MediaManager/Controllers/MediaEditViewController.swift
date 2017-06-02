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
    @IBOutlet public var mediaSubTypeView:UIView!
    @IBOutlet public var titleTextField:UITextField!
    @IBOutlet public var imageView:UIImageView!
    @IBOutlet public var mediaSubTypeSegmentedControl:UISegmentedControl!
    @IBOutlet public var tableView:UITableView!
    
    public var mediaType:MediaType?
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        // setup media image
        imageView.image = mediaType?.defaultImage
        
        // setup media sub types segmented control
        if let mediaSubTypes:[MediaSubType] = mediaType?.mediaSubTypes
        {
            var index:Int = 0
            
            mediaSubTypeSegmentedControl.removeAllSegments()
            
            for mediaSubType:MediaSubType in mediaSubTypes
            {
                mediaSubTypeSegmentedControl.insertSegment(withTitle: mediaSubType.name, at: index, animated: false)
                index += 1
            }
            
            mediaSubTypeSegmentedControl.selectedSegmentIndex = 0
        }
        else
        {
            mediaSubTypeView.removeFromSuperview()
        }
        
        // TODO(scott): fix this
        tableView.tableHeaderView!.sizeToFit()
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
    func didDownloadMedia(_ mediaManaged:ManagedObject)
    {
        
    }
}
