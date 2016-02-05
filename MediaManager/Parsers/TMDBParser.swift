//
//  TMDBParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class TMDBParser: JSONParser
{
    private let maxMediaResults:[MediaType: Int] = [
        .Movie: 1,
        .Show: 1
    ]
    
    private let mediaTypeMap:[String: MediaType] = [
        "movie": .Movie,
        "tv": .Show
    ]
    
    //afe4803cef4c0e689b7cbf339b767129
    //https://api.themoviedb.org/3/search/multi?api_key=afe4803cef4c0e689b7cbf339b767129&query=simpsons&page=1
    override init(completionHandler: (Media?) -> ())
    {
        super.init(completionHandler: completionHandler)
        
        searchParameterizedUrl = ParameterizedURL(
            url: "https://api.themoviedb.org/3/search/multi?api_key={api_key}&query={query}&page={page}",
            defaultParameters: [
                "page": "1"
            ],
            requiredParameterNames: ["api_key", "query"]
        )
    }
    
    
    override func objectifyJSON(json: AnyObject)
    {
        if let root:[String: AnyObject] = json as? [String: AnyObject]
        {
            if let results:[[String: AnyObject]] = root["results"] as? [[String: AnyObject]]
            {
                var resultsFound:[MediaType: Int] = [
                    .Movie: 0,
                    .Show: 0
                ]
                
                for result:[String: AnyObject] in results
                {
                    do
                    {
                        let mediaType:MediaType = mediaTypeMap[result["media_type"] as! String]!
                        
                        if (++resultsFound[mediaType]! <= maxMediaResults[mediaType]! || maxMediaResults[mediaType]! == -1)
                        {
                            let text:String = result["title"] as! String
                            var image:UIImage? = nil
                            
                            if let relImagePath:String = result["poster_path"] as? String
                            {
                                
                            }
                        }
                    }
                    catch
                    {
                        continue
                    }
                }
            }
        }
    }
}
