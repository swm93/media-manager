//
//  MediaObjectViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-31.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class MediaDetailViewController : UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var imageView:CircularImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var headerHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageMinHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageMaxHeightConstraint:NSLayoutConstraint!
    

    var mediaObject:Media?
    var data:[String: String]?
    {
        willSet(newValue)
        {
            if let newData:[String: String] = newValue
            {
                orderedKeys = newData.keys.sorted()
            }
            else
            {
                orderedKeys = nil
            }
            
            tableView.reloadData()
        }
    }
    private var orderedKeys:[String]?

    private let animationDuration:TimeInterval = 0.3
    private let headerHeightBounds:(min: CGFloat, max: CGFloat) = (min: 64.0, max: 160.0)
    private let cornerRadiusAnimation:CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
    
    private let minScrollOffset:CGFloat = 16.0
    private var lastScrollOffset:CGFloat?
    private var deltaScrollOffset:CGFloat?
    private var totalDeltaScrollOffset:CGFloat?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let artist: ArtistManaged = mediaObject as? ArtistManaged
        {
            data = [
                "bio": artist.summary ?? "",
                "genres": (artist.genres.flatMap({ ($0 as! GenreManaged).name })).joined(separator: ", ")
            ]
        }
        
        cornerRadiusAnimation.duration = animationDuration
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        cornerRadiusAnimation.fillMode = kCAFillModeForwards
        cornerRadiusAnimation.isRemovedOnCompletion = true

        imageView.image = createImage(for: mediaObject!)
        titleLabel.text = mediaObject!.name
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MediaDetailCell = tableView.dequeueReusableCell(withIdentifier: "MediaDetailCell", for: indexPath) as! MediaDetailCell
        
        if let key:String = orderedKeys?[indexPath.row]
        {
            cell.titleLabel.text = key.uppercased()
            cell.contentLabel.text = data?[key]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data?.count ?? 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        lastScrollOffset = scrollView.contentOffset.y
        totalDeltaScrollOffset = 0.0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let diffToMin:CGFloat = headerView.frame.height - headerHeightBounds.min
        let diffToMax:CGFloat = headerHeightBounds.max - headerView.frame.height
        let useDiff:Bool = (scrollView.isScrolledTop || scrollView.isScrolledBottom || totalDeltaScrollOffset != nil && abs(totalDeltaScrollOffset!) < minScrollOffset)
        var cornerRadiusToValue:CGFloat = 0.0
        
        if ((useDiff && diffToMin < diffToMax) || (!useDiff  && deltaScrollOffset > 0))
        {
            // animate to min height header
            headerHeightConstraint.constant = headerHeightBounds.min
            cornerRadiusToValue = imageMinHeightConstraint.constant / 2
        }
        else
        {
            // animate to max height header
            headerHeightConstraint.constant = headerHeightBounds.max
            cornerRadiusToValue = imageMaxHeightConstraint.constant / 2
        }
        
        cornerRadiusAnimation.toValue = cornerRadiusToValue
        cornerRadiusAnimation.fromValue = min(imageView.frame.height, imageView.frame.width) / 2
        imageView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
        
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            self?.tableView.layoutIfNeeded()
            self?.headerView.layoutIfNeeded()
        })
        
        
        lastScrollOffset = nil
        deltaScrollOffset = nil
        totalDeltaScrollOffset = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if let lastOffset:CGFloat = lastScrollOffset
        {
            let newOffset:CGFloat = scrollView.contentOffset.y
            let deltaOffset:CGFloat = newOffset - lastOffset
            let totalDeltaOffset:CGFloat = (totalDeltaScrollOffset ?? 0.0) + deltaOffset
            
            if (abs(totalDeltaOffset) > minScrollOffset)
            {
                let testHeight:CGFloat = headerView.frame.size.height - deltaOffset
                let newHeight:CGFloat = max(headerHeightBounds.min, min(headerHeightBounds.max, testHeight))
                if (newHeight != headerView.frame.size.height)
                {
                    headerHeightConstraint.constant = newHeight
                    headerView.layoutIfNeeded()
                }
            }
            lastScrollOffset = newOffset
            deltaScrollOffset = deltaOffset
            totalDeltaScrollOffset = totalDeltaOffset
        }
    }
    
    
    func createImage(for media:Media) -> UIImage
    {
        let mediaType:MediaType = type(of: media).type
        return media.imageData != nil ? UIImage(data: media.imageData! as Data)! : mediaType.defaultImage
    }
}
