//
//  SongManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class SongManaged : ManagedObject, Media
{
    @NSManaged var name:String
    @NSManaged var imageData:Data?
 
    
    static var type:MediaType {
        get {
            return .music
        }
    }
    
    
    convenience init()
    {
        self.init(entityType: .Song)
    }
}
