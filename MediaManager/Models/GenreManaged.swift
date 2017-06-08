//
//  GenreManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation



class GenreManaged : NSManagedObject, ManagedObject
{
    static let entityName:String = "Genre"
    
    @NSManaged var name:String
}
