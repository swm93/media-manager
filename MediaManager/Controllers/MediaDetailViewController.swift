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
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var imageView:CircularImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var headerHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageMinHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageMaxHeightConstraint:NSLayoutConstraint!
    

    var mediaObject: ManagedMedia!
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
    
    internal let _animationDuration:TimeInterval = 0.3
    internal let _headerHeightBounds:(min: CGFloat, max: CGFloat) = (min: 64.0, max: 160.0)
    internal let _cornerRadiusAnimation:CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
    
    internal let _minScrollOffset:CGFloat = 16.0
    internal var _lastScrollOffset:CGFloat?
    internal var _deltaScrollOffset:CGFloat?
    internal var _totalDeltaScrollOffset:CGFloat?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self._cornerRadiusAnimation.duration = self._animationDuration
        self._cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self._cornerRadiusAnimation.fillMode = kCAFillModeForwards
        self._cornerRadiusAnimation.isRemovedOnCompletion = true

        self.imageView.image = self.createImage(for: self.mediaObject)
        self.titleLabel.text = self.mediaObject.name
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140.0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "EditSegue")
        {
            let destinationVC: MediaEditViewController = segue.destination as! MediaEditViewController
            destinationVC.managedObject = self.mediaObject
        }
    }
    
    
    private func getCellData(managedObject: NSManagedObject, keyPrefix: String? = nil) -> [(label: String, value: String)]
    {
        var result: [(label: String, value: String)] = [(label: String, value: String)]()
        let managedObjectData: [String: Any] = managedObject.dictionaryWithValues(forKeys: Array(managedObject.entity.propertiesByName.keys))
        
        for (key, value) in managedObjectData
        {
            if (keyPrefix == nil && key.caseInsensitiveCompare("name") == ComparisonResult.orderedSame)
            {
                continue
            }
            
            let label: String = "\(keyPrefix ?? "")\(key)".uppercased()
            
            switch (value)
            {
            case let valueStr as String:
                result.append((label: label, value: valueStr))
                break
                
            case let valueInt as Int:
                let cellValue: String = secondsToString(seconds: valueInt / 1000)
                result.append((label: label, value: cellValue))
                break
                
            case let valueManaged as NSManagedObject:
                result += self.getCellData(managedObject: valueManaged, keyPrefix: "\(key) ")
                break
                
            default:
                break
            }
        }
        
        return result
    }
    
    
    private func createImage(for media: ManagedMedia) -> UIImage
    {
        return media.imageData != nil ? UIImage(data: media.imageData! as Data)! : type(of: media).type.defaultImage
    }
}



extension MediaDetailViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let data: (label: String, value: String) = self._cellData[indexPath.row]
        let cell:MediaDetailCell = tableView.dequeueReusableCell(withIdentifier: "MediaDetailCell", for: indexPath) as! MediaDetailCell
        cell.titleLabel.text = data.label
        cell.contentLabel.text = data.value
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._cellData.count
    }
}



extension MediaDetailViewController : UIScrollViewDelegate
{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self._lastScrollOffset = scrollView.contentOffset.y
        self._totalDeltaScrollOffset = 0.0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let diffToMin:CGFloat = self.headerView.frame.height - self._headerHeightBounds.min
        let diffToMax:CGFloat = self._headerHeightBounds.max - self.headerView.frame.height
        let useDiff:Bool = (
            scrollView.isScrolledTop ||
            scrollView.isScrolledBottom ||
            self._totalDeltaScrollOffset != nil && abs(self._totalDeltaScrollOffset!) < self._minScrollOffset
        )
        var cornerRadiusToValue:CGFloat = 0.0
        
        if ((useDiff && diffToMin < diffToMax) || (!useDiff  && (self._deltaScrollOffset ?? 0) > 0))
        {
            // animate to min height header
            self.headerHeightConstraint.constant = self._headerHeightBounds.min
            cornerRadiusToValue = imageMinHeightConstraint.constant / 2
        }
        else
        {
            // animate to max height header
            self.headerHeightConstraint.constant = self._headerHeightBounds.max
            cornerRadiusToValue = self.imageMaxHeightConstraint.constant / 2
        }
        
        self._cornerRadiusAnimation.toValue = cornerRadiusToValue
        self._cornerRadiusAnimation.fromValue = min(self.imageView.frame.height, self.imageView.frame.width) / 2
        self.imageView.layer.add(self._cornerRadiusAnimation, forKey: "cornerRadius")
        
        UIView.animate(withDuration: self._animationDuration, animations: { [weak self] in
            self?.tableView.layoutIfNeeded()
            self?.headerView.layoutIfNeeded()
        })
        
        
        self._lastScrollOffset = nil
        self._deltaScrollOffset = nil
        self._totalDeltaScrollOffset = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if let lastOffset:CGFloat = self._lastScrollOffset
        {
            let newOffset:CGFloat = scrollView.contentOffset.y
            let deltaOffset:CGFloat = newOffset - lastOffset
            let totalDeltaOffset:CGFloat = (self._totalDeltaScrollOffset ?? 0.0) + deltaOffset
            
            if (abs(totalDeltaOffset) > self._minScrollOffset)
            {
                let testHeight:CGFloat = self.headerView.frame.size.height - deltaOffset
                let newHeight:CGFloat = max(self._headerHeightBounds.min, min(self._headerHeightBounds.max, testHeight))
                if (newHeight != headerView.frame.size.height)
                {
                    self.headerHeightConstraint.constant = newHeight
                    self.headerView.layoutIfNeeded()
                }
            }
            self._lastScrollOffset = newOffset
            self._deltaScrollOffset = deltaOffset
            self._totalDeltaScrollOffset = totalDeltaOffset
        }
    }
}
