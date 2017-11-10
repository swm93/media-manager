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
    var dateReleased: Date? { get }
    var imageData: Data? { get }
    var genres: NSSet? { get }
    

    func value(for key: String) -> Any?
    func setValue(_ value: Any?, for key: String)
    func getString(forKey key: String) -> String?
    func getString(forKeyPath keyPath: String) -> String?
    func setString(_ value: String, forKey key: String)
    func setString(_ value: String, forKeyPath keyPath: String)
}
