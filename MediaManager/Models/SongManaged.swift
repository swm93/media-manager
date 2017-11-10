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



class SongManaged : NSManagedObject, ManagedMedia
{
    var imageData: Data?
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
    
    var primaryText: String?
    {
        get
        {
            return self.album?.artist?.name
        }
        
    }
    
    var secondaryText: String?
    {
        get
        {
            return self.album?.name
        }
    }
    
    var dateReleased: Date?
    {
        get
        {
            return self.album?.dateReleased
        }
    }
    
    
    public override func value(forUndefinedKey key: String) -> Any?
    {
        return nil
    }
}
