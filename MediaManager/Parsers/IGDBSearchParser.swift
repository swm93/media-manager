//
//  IGDBParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-05-18.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class IGDBSearchParser: JSONParser<[SearchResult]>
{
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "https://igdbcom-internet-game-database-v1.p.mashape.com/games/?fields={fields}&limit={limit}&offset={page}&search={query}",
            defaultParameters: [
                "page": "0",
                "limit": "5",
                "fields": "name,cover"
            ],
            requiredParameterNames: ["query"]
        )
        let headers:[String: String] = [
            "X-Mashape-Key": apiKey,
            "Accept": "application/json"
        ]
        
        super.init(parameterizedUrl, headers)
    }
    
    
    override func objectifyJSON(_ json: Any)
    {
        var results:[SearchResult] = [SearchResult]()
        
        if let root:[[String: Any]] = json as? [[String: Any]]
        {
            for result:[String: Any] in root
            {
                var text:String? = nil
                var image:UIImage? = nil
                var imageUrl:String? = nil
                
                text = result["name"] as? String
                
                if let cover:[String: Any] = result["cover"] as? [String: Any]
                {
                    imageUrl = cover["url"] as? String
                    
                    if let url:String = imageUrl
                    {
                        image = downloadImage(fromUrl: "http:\(url)")
                    }
                }
                
                if let t:String = text
                {
                    let result:SearchResult = SearchResult(
                        mediaType: .game,
                        parserType: .igdb,
                        primaryText: t,
                        image: image
                    )
                    results.append(result)
                }
            }
        }
        
        didFinishParsing(results)
    }
}
