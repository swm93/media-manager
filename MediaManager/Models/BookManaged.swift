//
//  BookManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class BookManaged : ManagedObject, Media
{
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var publishedBy:String?
    @NSManaged var publishedDate:Date?

    
    static var type:MediaType {
        get {
            return .book
        }
    }
    
    
    convenience init()
    {
        self.init(entityType: .Book)
    }
}
