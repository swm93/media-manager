//
//  MediaObjectViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-31.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class MediaDetailViewController : UIViewController
{
    @IBOutlet public weak var imageView:CircularImageView!
    @IBOutlet public weak var titleLabel:UILabel!
    @IBOutlet public weak var primarySubtitleLabel:UILabel!
    @IBOutlet public weak var secondarySubtitleLabel:UILabel!
    @IBOutlet public weak var yearLabel:UILabel!
    @IBOutlet public weak var tableViewContainer:UIView!
    

    public var mediaObject: ManagedMedia!
    {
        willSet(newValue)
        {
            var cellData: [(label: String, value: String)]
            
            if let managedObject: NSManagedObject = newValue as? NSManagedObject
            {
                cellData = self.getCellData(managedObject: managedObject)
            }
            else
            {
                cellData = [(label: String, value: String)]()
            }
            
            self._cellData = cellData
        }
    }

    internal var _cellData: [(label: String, value: String)]!
    
    private var _yearFormatter: DateFormatter
    

    
    required init?(coder aDecoder: NSCoder)
    {
        self._yearFormatter = DateFormatter()
        self._yearFormatter.dateFormat = "yyyy"
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.imageView.image = self.createImage(for: self.mediaObject)
        self.titleLabel.text = self.mediaObject.name
        self.primarySubtitleLabel.text = self.mediaObject.primaryText
        self.secondarySubtitleLabel.text = self.mediaObject.secondaryText
        self.yearLabel.text = self.getYearText(for: self.mediaObject)
        
        // setup table view
        var tableViewController: MediaDetailTableViewController? = nil
        
        switch(self.mediaObject)
        {
        case is BookManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookDetailTableViewController") as! BookDetailTableViewController
            break
            
        case is GameManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "GameDetailTableViewController") as! GameDetailTableViewController
            break
            
        case is MovieManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetailTableViewController") as! MovieDetailTableViewController
            break
            
        case is SongManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "MusicDetailTableViewController") as! MusicDetailTableViewController
            break
            
        case is ShowManaged:
            tableViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShowDetailTableViewController") as! ShowDetailTableViewController
            break
            
        default:
            break
        }
        
        
        tableViewController?.mediaObject = self.mediaObject
        
        if let controller: MediaDetailTableViewController = tableViewController
        {
            addChildViewController(controller)
            self.tableViewContainer.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "EditSegue")
        {
            let destinationVC: MediaEditViewController = segue.destination as! MediaEditViewController
            destinationVC.managedObject = self.mediaObject
        }
    }
    
    
    private func createImage(for media: ManagedMedia) -> UIImage
    {
        return media.imageData != nil ? UIImage(data: media.imageData! as Data)! : type(of: media).type.defaultImage
    }
    
    
    private func getYearText(for media: ManagedMedia) -> String?
    {
        var result: String? = nil
        
        if let date: Date = media.dateReleased as Date?
        {
            result = self._yearFormatter.string(from: date)
        }
        
        return result
    }
}
