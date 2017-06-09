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



class AuthorManaged : NSManagedObject, ManagedObject
{
    var genres:NSSet
    {
        get
        {
            return NSSet(array: books?.flatMap({ ($0 as! BookManaged).genres }) ?? [GenreManaged]())
        }
    }
    
    var image:UIImage
    {
        get
        {
            return UIImage(data: imageData! as Data)!
        }
        set
        {
            imageData = (UIImagePNGRepresentation(newValue) as NSData?)
        }
    }
}
