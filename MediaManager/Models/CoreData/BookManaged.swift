//
//  BookManaged.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-24.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation
import UIKit



class BookManaged : NSManagedObject, ManagedMedia
{
    static var type:MediaType
    {
        get
        {
            return .book
        }
    }
    
    var primaryText: String?
    {
        get
        {
            return self.authors?.flatMap({ ($0 as? AuthorManaged)?.name }).joined(separator: ", ")
        }
        
    }
    
    var secondaryText: String?
    {
        get
        {
            return nil
        }
    }
    
    
    public override func value(forUndefinedKey key: String) -> Any?
    {
        return nil
    }
}
