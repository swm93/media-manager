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
    override internal func objectifyData(_ data:Data?, response:URLResponse?, error:Error?)
    {
        if let d:Data = data
        {
            do
            {
                let json:Any = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                let result:T = objectifyJSON(json)
                
                didFinishParsing(result)
            }
            catch
            {
                print("Failed to parse JSON data")
            }
        }
    }
    
    
    internal func objectifyJSON(_ json:Any) -> T
    {
        assert(false, "This method must be overridden")
    }
}
