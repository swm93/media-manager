//
//  BookManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class BookManaged : NSManagedObject, ManagedObject, Media
{
    static let entityName:String = "Book"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var datePublished:Date?
    @NSManaged var genres:Set<GenreManaged>
    @NSManaged var authors:Set<AuthorManaged>
    
    static var type:MediaType
    {
        get
        {
            return .book
        }
    }
}
