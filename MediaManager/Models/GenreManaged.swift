//
//  GenreManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation



class GenreManaged : ManagedObject
{
    @NSManaged var name:String
    
    
    convenience init()
    {
        self.init(entityType: .Genre)
    }
}
