//
//  AuthorManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-07.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class AuthorManaged : NSManagedObject, ManagedObject
{
    static let entityName:String = "Author"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var biography:String?
    @NSManaged var books:Set<BookManaged>
    
    var genres:Set<GenreManaged>
    {
        get
        {
            return Set<GenreManaged>(books.flatMap({ $0.genres }))
        }
    }
    
    var image:UIImage
    {
        get
        {
            return UIImage(data: imageData!)!
        }
        set
        {
            imageData = UIImagePNGRepresentation(newValue)
        }
    }
}
