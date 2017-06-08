//
//  ManagedObjectManager.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-07.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class ManagedObjectManager
{
    public static func getBy<T:NSManagedObject, U:CVarArg>(attribute:String, value:U) -> [T]
        where T:ManagedObject
    {
        var results:[T]
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest:NSFetchRequest<T> = NSFetchRequest(entityName: entityName(type: T.self))
        fetchRequest.predicate = NSPredicate(format: "%K = %@", attribute, value)
        
        do
        {
            results = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            results = [T]()
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return results
    }
    
    
    public static func entityName<T:ManagedObject>(type: T.Type) -> String
    {
        switch (type)
        {
        case is AlbumManaged.Type:
            return "Album"
            
        case is ArtistManaged.Type:
            return "Artist"
            
        case is AuthorManaged.Type:
            return "Author"
            
        case is BookManaged.Type:
            return "Book"
            
        case is GameManaged.Type:
            return "Game"
            
        case is GenreManaged.Type:
            return "Genre"
            
        case is MovieManaged.Type:
            return "Movie"
            
        case is PlatformManaged.Type:
            return "Platform"
            
        case is ShowManaged.Type:
            return "Show"
            
        case is SongManaged.Type:
            return "Song"
            
        default:
            assert(false, "Entity name for ManagedObject not defined")
        }
    }
}
