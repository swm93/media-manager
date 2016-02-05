//
//  UIScrollViewExtension.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-02.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView
{
    var isScrolledTop:Bool
    {
        get
        {
            return contentOffset.y == 0
        }
    }
    
    var isScrolledBottom:Bool
    {
        get
        {
            return contentOffset.y + frame.size.height == contentSize.height
        }
    }
}