//
//  MovieManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class MovieManaged : NSManagedObject, ManagedMedia
{
    static var type:MediaType
    {
        get
        {
            return .movie
        }
    }
}
