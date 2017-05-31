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

    
    var mediaObjects:[MediaType: [Media]] = [MediaType: [Media]]()
    {
        didSet
        {
            mediaTable.reloadData()
        }
    }
    
    private var _mediaObjectTypes:[MediaType] {
        get {
            return mediaObjects.keys.sorted(by: {
                return $0.name > $1.name
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var mediaObjs:[MediaType: [Media]] = [MediaType: [Media]]()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest:NSFetchRequest<ArtistManaged> = NSFetchRequest(entityName: "Artist")
        
        do
        {
            let results:[Media] = try managedContext.fetch(fetchRequest)
            //let musicResults:[MediaManaged] = results.map({ $0 })
            mediaObjs[MediaType.music] = results
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
                let mediaType:MediaType = _mediaObjectTypes[indexPath.section]
                
                destinationVC.mediaObject = mediaObjects[mediaType]?[indexPath.row]
            }
        }
    }
    
    
    @IBAction func toggleFilterView()
    {
        filterViewTopConstraint.constant = (filterViewTopConstraint.constant == 0.0) ? -filterView.frame.height : 0.0
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.filterView.layoutIfNeeded()
            self?.mediaTable.layoutIfNeeded()
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        let titleLabel:UILabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(3) as! UIImageView
        
        let mediaType:MediaType = _mediaObjectTypes[indexPath.section]
        let mediaObject:Media? = mediaObjects[mediaType]?[indexPath.row]
        
        titleLabel.text = mediaObject?.name
        subtitleLabel.text = ""
        imageView.image = UIImage(data: mediaObject?.imageData ?? mediaType.defaultImageDataAsset.data)
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let mediaType:MediaType = _mediaObjectTypes[section]
        let count:Int = mediaObjects[mediaType]?.count ?? 0
        
        return count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return _mediaObjectTypes.count
    }
    
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]?
//    {
//        return [MediaType.book.name, MediaType.game.name, MediaType.movie.name, MediaType.music.name, MediaType.show.name]
//    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _mediaObjectTypes[section].name
    }
}
