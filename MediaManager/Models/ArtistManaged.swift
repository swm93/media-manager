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



class ArtistManaged : NSManagedObject, ManagedObject
{
    static let entityName:String = "Artist"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var summary:String?
    @NSManaged var albums:Set<AlbumManaged>?
    
    var genres:Set<GenreManaged>
    {
        get
        {
            var result:Set<GenreManaged>
            
            if let a:Set<AlbumManaged> = albums
            {
                result = Set<GenreManaged>(a.flatMap({ $0.genres }))
            }
            else
            {
                result = Set<GenreManaged>()
            }
            
            return result
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
