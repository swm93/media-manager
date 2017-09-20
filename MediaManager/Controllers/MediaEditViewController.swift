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
    @IBOutlet public var nameTextField:UITextField!
    @IBOutlet public var imageView:UIImageView!
    @IBOutlet public var tableViewContainer:UIView!
    
    public var managedObject:ManagedMedia!
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        self.nameTextField.text = self.managedObject.name
        
        // setup media image
        imageView.image = self.createImage(for: self.managedObject)
        
        // setup table view
        var tableViewController:MediaEditTableViewController? = nil
        
        switch(self.managedObject)
        {
        case is BookManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookEditTableViewController") as! BookEditTableViewController
            break
            
        case is GameManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "GameEditTableViewController") as! GameEditTableViewController
            break
            
        case is MovieManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MovieEditTableViewController") as! MovieEditTableViewController
            break
            
        case is SongManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MusicEditTableViewController") as! MusicEditTableViewController
            break
            
        case is ShowManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShowEditTableViewController") as! ShowEditTableViewController
            break
            
        default:
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
    
    
    private func createImage(for media: ManagedMedia) -> UIImage
    {
        return media.imageData != nil ? UIImage(data: media.imageData! as Data)! : type(of: media).type.defaultImage
    }
    
    
    @IBAction func save()
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do
        {
            try appDelegate.saveContext()
            
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        catch let error
        {
            print("Could not save \(error)")
        }
    }
    
    
    @IBAction func cancel()
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.persistentContainer.viewContext.rollback()
        
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nameTextFieldChanged()
    {
        managedObject?.name = self.nameTextField.text
    }
}
