//
//  LibraryThingParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class LibraryThingParser : APIParser
{
    let searchUrl:ParameterizedURL = ParameterizedURL(
        url: "https://www.librarything.com/services/rest/1.1/?method=librarything.ck.getwork&name={query}&apikey={api_key}",
        defaultParameters: nil,
        requiredParameterNames: ["api_key", "query"]
    )
    
    override internal func parse(data:NSData?, response:NSURLResponse?, error:NSError?) -> ()
    {
        
    }
}