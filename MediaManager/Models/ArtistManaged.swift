//
//  ArtistManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class ArtistManaged : NSManagedObject, ManagedMedia
{
    var genres:NSSet?
    {
        get
        {
            var result:NSSet
            
            if let a:NSSet = albums
            {
                result = NSSet(array: a.flatMap({ ($0 as! AlbumManaged).genres }))
            }
            else
            {
                result = NSSet()
            }
            
            return result
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
