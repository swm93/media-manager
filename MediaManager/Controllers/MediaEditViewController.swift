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
    @IBOutlet public var tableView:UITableView!
    
    public var mediaType:MediaType?
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        // setup media image
        imageView.image = mediaType?.defaultImage
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
