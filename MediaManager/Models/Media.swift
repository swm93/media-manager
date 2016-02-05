//
//  Media.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


protocol Media : CustomStringConvertible
{
    static var mediaType:String { get }
    var image:UIImage { get set }
    
    var summary:String? { get }
    var secondaryText:String? { get }
}
