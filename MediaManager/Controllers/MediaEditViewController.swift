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
    
    public var mediaType:MediaType!
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
            dismiss(animated: true)
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
        dismiss(animated: true)
    }
    
    
    @IBAction func nameTextFieldChanged()
    {
        managedObject?.name = self.nameTextField.text
    }
}
