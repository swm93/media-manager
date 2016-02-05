//
//  MediaObjectViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-31.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


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
                orderedKeys = newData.keys.sort()
            }
            else
            {
                orderedKeys = nil
            }
            
            tableView.reloadData()
        }
    }
    private var orderedKeys:[String]?

    private let animationDuration:NSTimeInterval = 0.3
    private let headerHeightBounds:(min: CGFloat, max: CGFloat) = (min: 64.0, max: 160.0)
    private let cornerRadiusAnimation:CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
    
    private let minScrollOffset:CGFloat = 16.0
    private var lastScrollOffset:CGFloat?
    private var deltaScrollOffset:CGFloat?
    private var totalDeltaScrollOffset:CGFloat?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        data = [
            "bio": "this is a sample",
            "date": "1970",
            "test1": "test",
            "test2": "test",
            "test3": "test",
            "test4": "test",
            "test5": "test",
            "test6": "test",
            "test7": "test",
            "test8": "test",
            "test9": "test",
            "test10": "test",
            "test11": "test",
            "test12": "test",
            "test13": "test",
            "test14": "test",
            "test15": "test",
            "test16": "test",
            "test17": "test",
            "test18": "test",
            "test19": "test"
        ]
        
        cornerRadiusAnimation.duration = animationDuration
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        cornerRadiusAnimation.fillMode = kCAFillModeForwards
        cornerRadiusAnimation.removedOnCompletion = true

        let artist:Artist = mediaObject as! Artist
        imageView.image = artist.image
        titleLabel.text = artist.name
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MediaDetailCell", forIndexPath: indexPath)
        
        if let key:String = orderedKeys?[indexPath.row]
        {
            cell.textLabel?.text = key
            cell.detailTextLabel?.text = data?[key]
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data?.count ?? 0
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        lastScrollOffset = scrollView.contentOffset.y
        totalDeltaScrollOffset = 0.0
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
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
        imageView.layer.addAnimation(cornerRadiusAnimation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(animationDuration)
        { [weak self] in
            self?.tableView.layoutIfNeeded()
            self?.headerView.layoutIfNeeded()
        }
        
        lastScrollOffset = nil
        deltaScrollOffset = nil
        totalDeltaScrollOffset = nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
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
}
