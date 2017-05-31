//
//  Media.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-25.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



protocol Media
{
    static var type:MediaType { get }
    
    var name:String { get }
    var imageData:Data? { get }
}
