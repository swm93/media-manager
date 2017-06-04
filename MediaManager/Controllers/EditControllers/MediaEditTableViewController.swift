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
    var mediaObject:ManagedObject!
    
    
    
    convenience init(mediaObject:ManagedObject)
    {
        self.init()
        
        self.mediaObject = mediaObject
    }
}
