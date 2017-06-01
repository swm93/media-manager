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
import HMSegmentedControl


class MediaViewController: UIViewController
{
    @IBOutlet weak var mediaTable:UITableView!
    @IBOutlet weak var mediaFilter:HMSegmentedControl!

    
    var mediaObjects:[MediaType: [MediaSubType: [Media]]] = [MediaType: [MediaSubType: [Media]]]()
    {
        didSet
        {
            mediaTable.reloadData()
        }
    }
    
    internal var _selectedMediaType:MediaType = .book
    {
        didSet
        {
            mediaTable.reloadData()
        }
    }
    
    internal var _mediaObjectSubTypes:[MediaSubType]
    {
        get
        {
            let mediaSubTypes = mediaObjects[_selectedMediaType]?.keys
            var sortedSubTypes:[MediaSubType]
            
            if (mediaSubTypes == nil)
            {
                sortedSubTypes = [MediaSubType]()
            }
            else
            {
                sortedSubTypes = mediaSubTypes!.sorted(by: {
                    return $0.name ?? "" > $1.name ?? ""
                })
            }
            
            return sortedSubTypes
        }
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mediaFilter.sectionTitles = MediaType.values.map { type in
            return type.name
        }
        mediaFilter.backgroundColor = (parent as? UINavigationController)?.navigationBar.barTintColor
        mediaFilter.selectionIndicatorHeight = 2.0
        mediaFilter.selectionIndicatorLocation = .down
        mediaFilter.selectionIndicatorColor = UIColor.white
        mediaFilter.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white
        ]
//        mediaFilter.addTarget(self, action: { value in
//            _selectedMediaType = value
//        }, for: UIControlEventValueChanged)
        mediaFilter.indexChangeBlock = { index in
            self._selectedMediaType = MediaType.values[index]
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var mediaObjs:[MediaType: [MediaSubType: [Media]]] = [MediaType: [MediaSubType: [Media]]]()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest:NSFetchRequest<ArtistManaged> = NSFetchRequest(entityName: "Artist")
        
        do
        {
            let results:[Media] = try managedContext.fetch(fetchRequest)
            
            if (mediaObjs[MediaType.music] == nil)
            {
                mediaObjs[MediaType.music] = [MediaSubType: [Media]]()
            }
            
            mediaObjs[MediaType.music]![MediaSubType.artist] = results
            mediaObjects = mediaObjs
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "MediaDetailSegue")
        {
            if let indexPath:IndexPath = mediaTable.indexPathForSelectedRow
            {
                let destinationVC:MediaDetailViewController = segue.destination as! MediaDetailViewController
                let mediaSubType:MediaSubType = _mediaObjectSubTypes[indexPath.section]
                
                destinationVC.mediaObject = mediaObjects[_selectedMediaType]?[mediaSubType]?[indexPath.row]
            }
        }
    }
}



extension MediaViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        
        let mediaSubType:MediaSubType = _mediaObjectSubTypes[indexPath.section]
        let mediaObject:Media? = mediaObjects[_selectedMediaType]?[mediaSubType]?[indexPath.row]
        
        titleLabel.text = mediaObject?.name
        subtitleLabel.text = ""
        imageView.image = mediaObject?.imageData != nil ? UIImage(data: mediaObject!.imageData!) : _selectedMediaType.defaultImage
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let mediaSubType:MediaSubType = _mediaObjectSubTypes[section]
        let count:Int = mediaObjects[_selectedMediaType]?[mediaSubType]?.count ?? 0
        
        return count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return _mediaObjectSubTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _mediaObjectSubTypes[section].name
    }
}
