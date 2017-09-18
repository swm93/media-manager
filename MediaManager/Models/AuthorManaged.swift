//
//  AuthorManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-07.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class AuthorManaged : NSManagedObject, ManagedMedia
{
    var genres:NSSet?
    {
        get
        {
            return NSSet(array: books?.flatMap({ ($0 as! BookManaged).genres }) ?? [GenreManaged]())
        }
    }
    
    static var type:MediaType
    {
        get
        {
            return .book
        }
    }
}
