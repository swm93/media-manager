//
//  MediaObjectViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-31.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import NYTPhotoViewer
import UIKit



class MediaDetailViewController : UIViewController
{
    @IBOutlet public weak var imageView: CircularImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    @IBOutlet public weak var tableView: UITableView!

    public var mediaObject: ManagedMedia!
    {
        didSet
        {
            self.detailData.removeAll()
            
            if let managedObject: NSManagedObject = self.mediaObject as? NSManagedObject
            {
                for (name, detailParser) in self._detailParsers
                {
                    if let value: Any = detailParser(managedObject)
                    {
                        self.detailData[name] = value
                    }
                }
            }
        }
    }
    public private(set) var detailData: [String: Any] = [String: Any]()
    
    internal var _detailParsers: [String: (NSManagedObject) -> Any?]
    
    internal var _mediaType: MediaType!
    
    private var _yearFormatter: DateFormatter
    

    
    required init?(coder aDecoder: NSCoder)
    {
        self._yearFormatter = DateFormatter()
        self._yearFormatter.dateFormat = "yyyy"
        
        self._detailParsers = [
//            "name": { (obj: NSManagedObject) -> String? in
//                if let value: String = obj.value(forKey: "name") as? String
//                {
//                    return value
//                }
//                return nil
//            },
            "summary": { (obj: NSManagedObject) -> String? in
                if let value: String = obj.value(forKey: "summary") as? String
                {
                    return value
                }
                return nil
            },
            "released": { (obj: NSManagedObject) -> Date? in
                if let value: NSDate = obj.value(forKey: "dateReleased") as? NSDate
                {
                    return value as Date
                }
                return nil
            },
//            "album": { (obj: NSManagedObject) -> String? in
//                if let value: AlbumManaged = obj.value(forKey: "album") as? AlbumManaged
//                {
//                    return value.name
//                }
//                return nil
//            },
//            "artist": { (obj: NSManagedObject) -> String? in
//                if let value: AlbumManaged = obj.value(forKey: "album") as? AlbumManaged
//                {
//                    return value.artist?.name
//                }
//                return nil
//            },
            "duration": { (obj: NSManagedObject) -> String? in
                if let value: Int = obj.value(forKey: "duration") as? Int
                {
                    return secondsToString(seconds: value / 1000)
                }
                return nil
            },
            "esrb": { (obj: NSManagedObject) -> String? in
                if let value: String = obj.value(forKey: "esrbRating") as? String
                {
                    return value
                }
                return nil
            },
            "track": { (obj: NSManagedObject) -> Int? in
                if let value: Int = obj.value(forKey: "trackNumber") as? Int
                {
                    return value
                }
                return nil
            },
            "authors": { (obj: NSManagedObject) -> [String]? in
                if let value: Set<AuthorManaged> = obj.value(forKey: "authors") as? Set<AuthorManaged>
                {
                    return value.flatMap { $0.name }
                }
                return nil
            },
            "genres": { (obj: NSManagedObject) -> [String]? in
                if let value: Set<GenreManaged> = obj.value(forKey: "genres") as? Set<GenreManaged>
                {
                    return value.flatMap { $0.name }
                }
                return nil
            },
            "platforms": { (obj: NSManagedObject) -> [String]? in
                if let value: Set<PlatformManaged> = obj.value(forKey: "platforms") as? Set<PlatformManaged>
                {
                    return value.flatMap { $0.name }
                }
                return nil
            },
//            "image": { (obj: NSManagedObject) -> UIImage? in
//                if let value: Data = obj.value(forKey: "imageData") as? Data
//                {
//                    return UIImage(data: value)
//                }
//                return nil
//            }
        ]
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for viewController: UIViewController in self.childViewControllers
        {
            if let controlsViewController: MediaDetailControlsViewController = viewController as? MediaDetailControlsViewController
            {
                controlsViewController.mediaObject = self.mediaObject
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = self.mediaObject.name
        self.subtitleLabel.text = self.getSubtitleText()
        
        if let imageData: Data = mediaObject?.imageData as Data?
        {
            self.imageView.image = UIImage(data: imageData)
            self.imageView.contentMode = .scaleAspectFill
        }
        else
        {
            self.imageView.image = type(of: self.mediaObject!).type.defaultImage
            self.imageView.contentMode = .center
        }
        
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "MediaEditSegue")
        {
            let destinationVC: MediaEditViewController = segue.destination as! MediaEditViewController
            destinationVC.mediaObject = self.mediaObject
        }
    }
    
    
    @IBAction func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imageView: UIImageView = tapGestureRecognizer.view as! UIImageView
        let photo: NYTPhoto = Photo(
            image: imageView.image!,
            title: self.mediaObject.name,
            summary: self.getSubtitleText()
        )
        let imageViewController: NYTPhotosViewController = NYTPhotosViewController(photos: [photo])
        
        self.present(imageViewController, animated: true)
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



extension MediaDetailViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.detailData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let keys: [String] = Array(self.detailData.keys)
        let value: Any? = self.detailData[keys[section]]
        
        switch (value)
        {
        case let v as Array<Any>:
            return v.count
            
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return Array(self.detailData.keys)[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: LabelDetailCell? = tableView.dequeueReusableCell(withIdentifier: "LabelDetailCell", for: indexPath) as? LabelDetailCell
        if (cell == nil)
        {
            cell = LabelDetailCell()
        }
        
        let keys: [String] = Array(self.detailData.keys)
        let key: String = keys[indexPath.section]
        var value: Any? = self.detailData[key]
        
        if let arrayValue: Array<Any> = value as? Array<Any>
        {
            value = arrayValue[indexPath.row]
        }
        
        switch (value)
        {
        case let v as String:
            cell?.value.text = v
        
        case let v as Int:
            cell?.value.text = String(v)
        
        case let v as Float:
            cell?.value.text = String(v)
        
        case let v as Double:
            cell?.value.text = String(v)
        
        case let v as Date:
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "MM dd, yyyy"
            cell?.value.text = formatter.string(from: v)
        
        default:
            cell?.value.text = ""
        }
        
        return cell!
    }
    
    func getSubtitleText() -> String?
    {
        var result: String? = nil
        
        if let leftText: String = self.mediaObject.primaryText
        {
            result = leftText
        }
        
        if let rightText: String = self.mediaObject.secondaryText
        {
            if (result == nil)
            {
                result = rightText
            }
            else
            {
                result?.append(" - \(rightText)")
            }
        }

        return result
    }
}
