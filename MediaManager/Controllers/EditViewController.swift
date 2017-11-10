//
//  EditViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-08.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class EditViewController : UIViewController, UITableViewDataSource, EditCellDelegate
{
    @IBOutlet public var nameTextField: UITextField!
    @IBOutlet public var imageView: UIImageView!
    @IBOutlet public var tableView: UITableView!
    
    public var mediaObject: ManagedMedia!
    {
        didSet
        {
            let mediaType: MediaType = type(of: self.mediaObject).type
            self._fields = self._fieldSets[mediaType]
        }
    }
    
    private var _fields: [[(String, String, String)]]!
    private let _fieldSets: [MediaType: [[(String, String, String)]]] = [
        .music: [
            [
                ("album.artist.name", "EditStringCell", "Artist"),
                ("album.name", "EditStringCell", "Album"),
                ("trackNumber", "EditNumberCell", "Track Number")
            ],
            [
                ("duration", "EditTimeCell", "Duration")
            ]
        ]
    ]
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // set transition style here so that it only applies on dismissal
        modalTransitionStyle = .crossDissolve
        
        self.nameTextField.text = self.mediaObject.name
        
        // setup media image
        if let imageData: Data = self.mediaObject?.imageData as Data?
        {
            self.imageView.image = UIImage(data: imageData)
            self.imageView.contentMode = .scaleAspectFill
        }
        else
        {
            self.imageView.image = type(of: self.mediaObject!).type.defaultImage
            self.imageView.contentMode = .center
        }
    }
    
    
    @IBAction func save()
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do
        {
            try appDelegate.saveContext()
            
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            
            if let destination: MediaDetailViewController = self.navigationController?.topViewController as? MediaDetailViewController
            {
                destination.mediaObject = self.mediaObject
            }
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let (key, cellId, label): (String, String, String) = self._fields[indexPath.section][indexPath.row]
        
        switch (cellId)
        {
        case "EditDateCell":
            var c: EditDateCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditDateCell
            if (c == nil)
            {
                c = EditDateCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditDateCell.ValueType
            return c!
            
        case "EditNumberCell":
            var c: EditNumberCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditNumberCell
            if (c == nil)
            {
                c = EditNumberCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditNumberCell.ValueType
            return c!
            
        case "EditStringCell":
            var c: EditStringCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditStringCell
            if (c == nil)
            {
                c = EditStringCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditStringCell.ValueType
            return c!
            
        case "EditStringArrayCell":
            var c: EditStringArrayCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditStringArrayCell
            if (c == nil)
            {
                c = EditStringArrayCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditStringArrayCell.ValueType
            return c!
            
        case "EditTextCell":
            var c: EditTextCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditTextCell
            if (c == nil)
            {
                c = EditTextCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditTextCell.ValueType
            return c!
            
        case "EditTimeCell":
            var c: EditTimeCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditTimeCell
            if (c == nil)
            {
                c = EditTimeCell()
            }
            c!.key = key
            c!.label.text = label
            c!.value = self.mediaObject.value(for: key) as? EditTimeCell.ValueType
            return c!
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self._fields.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._fields[section].count
    }
    
    
    func editCellChangedValue(_ value: Any?, forKey key: String)
    {
        self.mediaObject.setValue(value, for: key)
    }
}
