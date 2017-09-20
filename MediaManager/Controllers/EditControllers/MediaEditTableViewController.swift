//
//  MediaEditTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-03.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class MediaEditTableViewController : UITableViewController
{
    public var mediaObject: ManagedMedia!
    public var dateFormat: String = "yyyy-MM-dd"
    {
        didSet
        {
            self.dateFormatter.dateFormat = dateFormat
        }
    }
    
    public private (set) var dateFormatter: DateFormatter = DateFormatter()
    
    
    
    convenience init(mediaObject: ManagedMedia)
    {
        self.init()
        
        self.mediaObject = mediaObject
    }
}
