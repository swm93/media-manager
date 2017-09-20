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

    
    var mediaObjects:[MediaType: [ManagedMedia]] = [MediaType: [ManagedMedia]]()
    {
        didSet
        {
            // set _groupedMediaObjects
            var groupedMediaObjects:[MediaType: [TableSection<ManagedMedia>]] = [MediaType: [TableSection<ManagedMedia>]]()
            for (type, media) in mediaObjects
            {
                let sortedMedia:[ManagedMedia] = media.sorted { $0.name! < $1.name! }
                var tableSections:[TableSection<ManagedMedia>] = [TableSection<ManagedMedia>]()
                for m in sortedMedia
                {
                    let firstChar:String = "\(m.name?.characters.first ?? Character(""))"
                    if (tableSections.count < 1 || tableSections[tableSections.count - 1].name != firstChar)
                    {
                        tableSections.append(TableSection<ManagedMedia>(name: firstChar, objects: [ManagedMedia]()))
                    }
                    
                    tableSections[tableSections.count - 1].objects.append(m)
                }
                
                groupedMediaObjects[type] = tableSections
            }
            
            _groupedMediaObjects = groupedMediaObjects
            
            // reload the table
            mediaTable.reloadData()
        }
    }
    
    internal var _groupedMediaObjects:[MediaType: [TableSection<ManagedMedia>]] = [MediaType: [TableSection<ManagedMedia>]]()
    
    internal let _tableViewSectionHeaders:[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    internal var _selectedMediaType:MediaType = .book
    {
        didSet
        {
            mediaTable.reloadData()
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
        mediaFilter.indexChangeBlock = { index in
            self._selectedMediaType = MediaType.values[index]
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let results:[SongManaged] = ManagedObjectManager.all(fetchRequest: SongManaged.fetchRequest())
        mediaObjects[MediaType.music] = results
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier)
        {
        case .some("MediaDetailSegue"):
            if let indexPath:IndexPath = mediaTable.indexPathForSelectedRow
            {
                let destinationVC:MediaDetailViewController = segue.destination as! MediaDetailViewController
                
                destinationVC.mediaObject = _groupedMediaObjects[_selectedMediaType]?[indexPath.section].objects[indexPath.row]
            }
            break
            
        case .some("MediaSearchSegue"):
            let navigationVC: UINavigationController = segue.destination as! UINavigationController
            let destinationVC: SearchViewController = navigationVC.viewControllers.first as! SearchViewController
            destinationVC.mediaType = self._selectedMediaType
            break
            
        default:
            break
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
        
        let mediaObject:ManagedMedia? = _groupedMediaObjects[_selectedMediaType]?[indexPath.section].objects[indexPath.row]
        
        titleLabel.text = mediaObject?.name
        subtitleLabel.text = mediaObject?.primaryText
        imageView.image = mediaObject?.imageData != nil ? UIImage(data: mediaObject!.imageData! as Data) : _selectedMediaType.defaultImage
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count:Int = _groupedMediaObjects[_selectedMediaType]?[section].objects.count ?? 0
        
        return count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return _groupedMediaObjects[_selectedMediaType]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return _groupedMediaObjects[_selectedMediaType]?[section].name
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return _tableViewSectionHeaders
    }
}
