//
//  TableCellRenderable.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-09.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


protocol TableCellRenderable
{
    var image:UIImage { get }
    var primaryText:String { get }
    var secondaryText:String { get }
}