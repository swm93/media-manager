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
    
    
    static let values:[MediaType] = [.book, .game, .movie, .music, .show]
    
    var name:String
    {
        var name:String
        
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
        
        return name
    }
    
    var defaultImage:UIImage
    {
        return self.greyImage
    }
    
    var blackImage:UIImage
    {
        return UIImage(named: "\(self.name)Black")!
    }
    
    var colorImage:UIImage
    {
        return UIImage(named: "\(self.name)Color")!
    }
    
    var greyImage:UIImage
    {
        return UIImage(named: "\(self.name)Grey")!
    }
}
