//
//  Movie.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class Movie : Media
{
    static let defaultImage:UIImage = UIImage(named: "MovieGrey")!
    static let mediaType:String = "movie"

    let name:String
    let genres:[String]
    private var image_:UIImage? = nil
    
    var image:UIImage
    {
        get
        {
            return image_ ?? Movie.defaultImage
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
            return name
        }
    }
    
    var summary:String?
    {
        get
        {
            return ""
        }
    }

    var secondaryText:String?
    {
        get
        {
            return genres.first
        }
    }
    
    
    init(name:String, genres:[String], image:UIImage?=nil)
    {
        self.name = name
        self.genres = genres
        self.image_ = image
    }
}