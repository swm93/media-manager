//
//  MediaSubType.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-31.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation



enum MediaSubType
{
    case none
    case artist
    case album
    case song
    
    
    var name:String?
    {
        var name:String?
        
        switch(self)
        {
        case .artist:
            name = "Artist"
        case .album:
            name = "Album"
        case .song:
            name = "Song"
        default:
            name = nil
        }
        
        return name
    }
    
    var mediaType:MediaType?
    {
        var type:MediaType?
        
        switch(self)
        {
        case .artist: fallthrough
        case .album: fallthrough
        case .song:
            type = .music
        default:
            type = nil
        }
        
        return type
    }
}
