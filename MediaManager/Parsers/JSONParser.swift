//
//  JSONParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-05.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class JSONParser : APIParser
{
    override internal func parse(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        if let d:NSData = data
        {
            do
            {
                let json:AnyObject = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments)
                objectifyJSON(json)
            }
            catch
            {
                print("Failed to parse JSON data")
            }
        }
    }
    
    
    internal func objectifyJSON(json:AnyObject) -> ()
    {
        assert(false, "This method must be overridden")
    }
}