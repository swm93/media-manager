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



class AlbumManaged : NSManagedObject, ManagedObject
{
    static let entityName:String = "Album"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var dateReleased:Date?
    @NSManaged var artist:ArtistManaged?
    @NSManaged var genres:Set<GenreManaged>
}
