//
//  GameManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class GameManaged : NSManagedObject, ManagedObject, Media
{
    static let entityName:String = "Game"
    
    @NSManaged var name:String
    @NSManaged var imageData:Data?
    @NSManaged var summary:String?
    @NSManaged var esrbRating:String?
    @NSManaged var genres:Set<GenreManaged>
    
    static var type:MediaType
    {
        get
        {
            return .game
        }
    }
}
