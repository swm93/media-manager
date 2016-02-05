//
//  Artist.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Artist : Media
{
    static let defaultImage:UIImage = UIImage(named: "MusicGrey")!
    static let mediaType:String = "music"

    var name:String? =  nil
    var summary:String? = nil
    var genres:[String] = [String]()
    private var image_:UIImage? = nil
    
    
    var image:UIImage
    {
        get
        {
            return image_ ?? Artist.defaultImage
        }

        set(newImage)
        {
            image_ = newImage
        }
    }
    
    var description:String
    {
        get
        {
            return name ?? ""
        }
    }
    
    var secondaryText:String?
    {
        get
        {
            return genres.first
        }
    }
}



class MediaManaged : NSManagedObject
{
    @NSManaged var name:String
}


class AlbumManaged : MediaManaged
{
    
}

class ArtistManaged : MediaManaged
{
    @NSManaged var image:NSData?
    @NSManaged var summary:String?
}

class BookManaged : MediaManaged
{
    @NSManaged var publishedBy:String?
    @NSManaged var publishedDate:NSDate?
}

class GameManaged : MediaManaged
{
    
}

class MovieManaged : MediaManaged
{
    
}

class ShowManaged : MediaManaged
{
    
}

class SongManaged : MediaManaged
{
    
}
