//
//  ArtistManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class ArtistManaged : ManagedObject, Media
{
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var thumbnail:Data?
    @NSManaged var summary:String?
    @NSManaged var genres:NSSet
    
    static var type:MediaType {
        get {
            return .music
        }
    }
    
    
    var image:UIImage {
        get {
            return UIImage(data: imageData!)!
        }
        set {
            
        }
    }
    
    
    convenience init()
    {
        self.init(entityType: .Artist)
    }
    
    func addGenre(_ genre: GenreManaged)
    {
        self.mutableSetValue(forKey: "genres").add(genre)
    }
}
