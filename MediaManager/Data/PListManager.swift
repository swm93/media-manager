//
//  PListManager.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-29.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation


class PListManager
{
    private static var _plistCache:[String: [String: Any]] = [String: [String: Any]]()
    
    private let _plist:[String: Any]
    
    
    
    init(_ name:String)
    {
        var result:[String: Any]? = PListManager._plistCache[name]
        
        if (result == nil)
        {
            if let path = Bundle.main.path(forResource: name, ofType: "plist")
            {
                if let dict = NSDictionary(contentsOfFile: path) as? [String: Any]
                {
                    PListManager._plistCache[name] = dict
                    result = dict
                }
            }
        }
        
        _plist = result!
    }
    
    
    subscript (key:String) -> Any?
    {
        return _plist[key]
    }
}
