//
//  SongManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class SongManaged : NSManagedObject, ManagedObject, Media
{
    var imageData: NSData?
    {
        get
        {
            return self.album?.imageData
        }
    }

    var genres:NSSet?
    {
        get
        {
            return self.album?.genres
        }
    }
    
    static var type:MediaType
    {
        get
        {
            return .music
        }
    }
}
