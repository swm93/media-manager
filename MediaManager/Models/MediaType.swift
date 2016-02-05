//
//  MediaType.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


enum MediaType
{
    case Book
    case Game
    case Movie
    case Music
    case Show
    
    
    var defaultImage:UIImage
        {
            let imagePostfix:String = "Grey"
            var imagePrefix:String
            
            switch(self)
            {
            case Book:
                imagePrefix = "Book"
            case Game:
                imagePrefix = "Game"
            case Movie:
                imagePrefix = "Movie"
            case Music:
                imagePrefix = "Music"
            case Show:
                imagePrefix = "Show"
            }
            
            return UIImage(named: imagePrefix + imagePostfix)!
    }
}