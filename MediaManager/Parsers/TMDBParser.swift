//
//  TMDBParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class TMDBParser: JSONParser<[SearchResult]>
{
    private let maxMediaResults:[MediaType: Int] = [
        .movie: 1,
        .show: 1
    ]
    
    private let mediaTypeMap:[String: MediaType] = [
        "movie": .movie,
        "tv": .show
    ]
    
    //https://api.themoviedb.org/3/search/multi?api_key=API_KEY&query=simpsons&page=1
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "https://api.themoviedb.org/3/search/multi?api_key={api_key}&query={query}&page={page}",
            defaultParameters: [
                "api_key": apiKey,
                "page": "1"
            ],
            requiredParameterNames: ["query"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override func objectifyJSON(_ json: Any)
    {
        var results:[SearchResult] = [SearchResult]()
        
        if let root:[String: Any] = json as? [String: Any]
        {
            if let jsonResults:[[String: Any]] = root["results"] as? [[String: Any]]
            {
                var resultsFound:[MediaType: Int] = [
                    .movie: 0,
                    .show: 0
                ]
                
                for jsonResult:[String: Any] in jsonResults
                {
                    let mediaType:MediaType = mediaTypeMap[jsonResult["media_type"] as! String]!
                    
                    resultsFound[mediaType]! += 1
                    
                    if (resultsFound[mediaType]! <= maxMediaResults[mediaType]! || maxMediaResults[mediaType]! == -1)
                    {
                        var text:String? = nil
                        var image:UIImage? = nil
                        
                        switch (mediaType)
                        {
                        case .movie:
                            text = jsonResult["title"] as? String
                        case .show:
                            text = jsonResult["name"] as? String
                        default:
                            break
                        }
                        
                        
                        if let relImagePath:String = jsonResult["poster_path"] as? String
                        {
                            image = downloadImage(fromUrl: relImagePath)
                        }
                        
                        if let t:String = text
                        {
                            let result:SearchResult = SearchResult(
                                detailParameters: [String: String](),
                                primaryText: t,
                                secondaryText: nil,
                                image: image ?? MediaType.movie.defaultImage
                            )
                            results.append(result)
                        }
                    }
                }
            }
        }
        
        didFinishParsing(results)
    }
}
