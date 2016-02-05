//
//  TVDBParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


class TVDBParser : APIParser
{
    let searchUrl:ParameterizedURL = ParameterizedURL(
        url: "/search/multi?api_key={api_key}&query={query}&page={page}&include_adult={include_adult}",
        defaultParameters: [
            "page": "1",
            "include_adult": "false"
        ],
        requiredParameterNames: ["api_key", "query"]
    )
    
    override internal func parse(data:NSData?, response:NSURLResponse?, error:NSError?) -> ()
    {
        
    }
}