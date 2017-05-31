//
//  Tree.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-20.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class XMLNode
{
    var parent:XMLNode? = nil
    var value:String? = nil
    var attributes:[String: String] = [String: String]()
    private var children:[String: [XMLNode]] = [String: [XMLNode]]()
    
    
    init(parent:XMLNode? = nil, value:String? = nil, attributes:[String: String]? = nil)
    {
        self.parent = parent
        self.value = value
        
        if let attrs:[String: String] = attributes
        {
            self.attributes = attrs
        }
    }
    
    subscript(key:String) -> [XMLNode]?
    {
        get
        {
            return children[key]
        }
        
        set(newValue)
        {
            children[key] = newValue
        }
    }
}
