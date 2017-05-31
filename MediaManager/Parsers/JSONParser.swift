//
//  JSONParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-05.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class JSONParser<T> : APIParser<T>
{
    override internal func parse(_ data:Data?, response:URLResponse?, error:Error?)
    {
        if let d:Data = data
        {
            do
            {
                let json:Any = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                objectifyJSON(json)
            }
            catch
            {
                print("Failed to parse JSON data")
            }
        }
    }
    
    
    internal func objectifyJSON(_ json:Any)
    {
        assert(false, "This method must be overridden")
    }
}
