//
//  MediaEditViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-08.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class MediaEditViewController : UIViewController, UITableViewDataSource, EditCellDelegate
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
        .book: [
            [
                ("dateReleased", "EditDateCell", "Date Released")
            ],
            [
                ("plot", "EditTextCell", "Plot")
            ]
        ],
        .game: [
            [
                ("esrbRating", "EditNumberCell", "ESRB Rating"),
                ("dateReleased", "EditDateCell", "Date Released")
            ],
            [
                ("summary", "EditTextCell", "Summary")
            ]
        ],
        .movie: [
            [
                ("duration", "EditTimeCell", "Duration"),
                ("dateReleased", "EditDateCell", "Date Released")
            ],
            [
                ("plot", "EditTextCell", "Plot")
            ]
        ],
        .music: [
            [
                ("album.artist.name", "EditStringCell", "Artist"),
                ("album.name", "EditStringCell", "Album"),
                ("trackNumber", "EditNumberCell", "Track Number"),
                ("duration", "EditTimeCell", "Duration"),
                ("album.dateReleased", "EditDateCell", "Date Released")
            ],
            [
                ("summary", "EditTextCell", "Summary")
            ],
            [
                ("lyrics", "EditTextCell", "Lyrics")
            ]
        ],
        .show: [
            [
                ("duration", "EditTimeCell", "Duration"),
                ("dateReleased", "EditDateCell", "Date Released")
            ],
            [
                ("summary", "EditTextCell", "Summary")
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
    
    
    @IBAction func nameFieldChanged(_ sender: UITextField)
    {
        var value: String? = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (value == "")
        {
            value = nil
        }
        
        self.mediaObject.name = value
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        let (key, cellId, label): (String, String, String) = self._fields[indexPath.section][indexPath.row]
        
        if var editCell: EditCell & UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EditCell & UITableViewCell
        {
            editCell.key = key
            editCell.label.text = label
            editCell.value = self.mediaObject.value(for: key)
            
            cell = editCell
        }
        else
        {
            cell = UITableViewCell()
        }
        
//        switch (cellId)
//        {
//        case "EditDateCell":
//            let c: EditDateCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        case "EditNumberCell":
//            let c: EditNumberCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        case "EditStringCell":
//            let c: EditStringCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        case "EditStringArrayCell":
//            let c: EditStringArrayCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        case "EditTextCell":
//            let c: EditTextCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        case "EditTimeCell":
//            let c: EditTimeCell = self.dequeueReusableCell(tableView, for: indexPath)
//            cell = c
//
//        default:
//            cell = UITableViewCell()
//        }
        
        return cell
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
    
    
//    private func dequeueReusableCell<T>(_ tableView: UITableView, for indexPath: IndexPath) -> T
//        where T : EditCell & UITableViewCell
//    {
//        let (key, cellId, label): (String, String, String) = self._fields[indexPath.section][indexPath.row]
//        var cell: UITableViewCell
//        if var editCell: T = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? T
//        {
//            editCell.key = key
//            editCell.label.text = label
//            editCell.value = self.mediaObject.value(for: key) as? T.ValueType
//
//            cell = editCell
//        }
//        else
//        {
//            cell = UITableViewCell()
//        }
//
//        return cell
//    }
}
