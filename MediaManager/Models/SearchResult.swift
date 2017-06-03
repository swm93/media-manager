//
//  SearchResult.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


struct SearchResult
{
    var detailParameters:[String: String]
    var primaryText:String
    var secondaryText:String?
    var image:UIImage?
    
    
    init(detailParameters:[String: String], primaryText:String, secondaryText:String?=nil, image:UIImage?=nil)
    {
        self.detailParameters = detailParameters
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
    }
}
