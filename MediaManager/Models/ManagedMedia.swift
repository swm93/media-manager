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
    
    var name:String? { get set }
    var imageData:NSData? { get }
    var genres:NSSet? { get }
}
