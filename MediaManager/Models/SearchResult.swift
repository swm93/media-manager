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
    var mediaType:MediaType
    
    var text:String
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
    
    
    init(type:MediaType, text:String, image:UIImage?=nil)
    {
        self.mediaType = type
        self.text = text
        self.image = image
    }
}