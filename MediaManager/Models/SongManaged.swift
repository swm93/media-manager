//
//  SongManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class SongManaged : NSManagedObject, ManagedObject, Media
{
    static let entityName:String = "Show"
    
    @NSManaged var name:String
    @NSManaged var trackNumber:Int16
    @NSManaged var duration:Int16
    @NSManaged var album:AlbumManaged?
    
    var imageData:Data?
    {
        get
        {
            return self.album?.imageData
        }
        set
        {
            album?.imageData = newValue
        }
    }
 
    var artist:ArtistManaged?
    {
        get
        {
            return self.album?.artist
        }
    }
    
    var genres:Set<GenreManaged>
    {
        get
        {
            return self.album?.genres ?? Set<GenreManaged>()
        }
    }

    static var type:MediaType
    {
        get
        {
            return .music
        }
    }
}
