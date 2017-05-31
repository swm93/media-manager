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
    case book
    case game
    case movie
    case music
    case show
    
    
    var name:String
    {
        var name:String?
        
        switch(self)
        {
        case .book:
            name = "Book"
        case .game:
            name = "Game"
        case .movie:
            name = "Movie"
        case .music:
            name = "Music"
        case .show:
            name = "Show"
        }
        
        return name!
    }
    
    var defaultImageDataAsset:NSDataAsset
    {
        return self.greyImageDataAsset
    }
    
    var blackImageDataAsset:NSDataAsset
    {
        return NSDataAsset(name: "\(self.name)Black")!
    }
    
    var colorImageDataAsset:NSDataAsset
    {
        return NSDataAsset(name: "\(self.name)Color")!
    }
    
    var greyImageDataAsset:NSDataAsset
    {
        return NSDataAsset(name: "\(self.name)Grey")!
    }
}
