//
//  MovieManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class MovieManaged : NSManagedObject, ManagedObject, Media
{
    static let entityName:String = "Movie"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var dateReleased:Date?
    @NSManaged var genres:Set<GenreManaged>
    
    static var type:MediaType
    {
        get
        {
            return .movie
        }
    }
}
