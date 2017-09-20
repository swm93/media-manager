//
//  ManagedObject.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation



protocol ManagedMedia
{
    static var type:MediaType { get }
    
    var name: String? { get set }
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var dateReleased: NSDate? { get }
    var imageData: NSData? { get }
    var genres: NSSet? { get }
}
