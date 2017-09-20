//
//  AlbumManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class AlbumManaged : NSManagedObject, ManagedMedia
{
    static var type:MediaType
    {
        get
        {
            return .music
        }
    }
    
    var primaryText: String?
    {
        get
        {
            return self.artist?.name
        }
    
    }
    
    var secondaryText: String?
    {
        get
        {
            return nil
        }
    }
}
