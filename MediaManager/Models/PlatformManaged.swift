//
//  PlatformManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-07.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class PlatformManaged : NSManagedObject, ManagedObject
{
    static let entityName:String = "Platform"
    
    @NSManaged var name:String
    @NSManaged var games:Set<GameManaged>
    
    var genres:Set<GenreManaged>
    {
        get
        {
            return Set<GenreManaged>(games.flatMap({ $0.genres }))
        }
    }
}
