//
//  ManagedObject.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class ManagedObject : NSManagedObject
{
    convenience internal init(entityType: EntityType)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: entityType.rawValue, in: appDelegate.managedObjectContext)!
        
        self.init(entity: entity, insertInto: appDelegate.managedObjectContext)
    }
}
