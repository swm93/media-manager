//
//  SearchResult.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class SearchResult
{
    let mediaType:MediaType
    let parserType:ParserType
    
    var primaryText:String
    var secondaryText:String?
    var image:UIImage?
    {
        get
        {
            return image_ ?? mediaType.defaultImage
        }
        set
        {
            image_ = newValue
        }
    }
    private var image_:UIImage?
    
    
    init(mediaType:MediaType, parserType:ParserType, primaryText:String, secondaryText:String?=nil, image:UIImage?=nil)
    {
        self.mediaType = mediaType
        self.parserType = parserType
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
    }
}
