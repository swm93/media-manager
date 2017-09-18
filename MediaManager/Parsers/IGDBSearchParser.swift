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
                "fields": "id,name,cover"
            ],
            requiredParameterNames: ["query"]
        )
        let headers:[String: String] = [
            "X-Mashape-Key": apiKey,
            "Accept": "application/json"
        ]
        
        super.init(parameterizedUrl, headers)
    }
    
    
    override func objectifyJSON(_ json: Any) -> [SearchResult]
    {
        var results:[SearchResult] = [SearchResult]()
        
        if let root:[[String: Any]] = json as? [[String: Any]]
        {
            for result:[String: Any] in root
            {
                var identifier:Int64? = nil
                var primaryText:String? = nil
                var image:UIImage? = nil
                var imageUrl:String? = nil
                
                // get identifier
                identifier = result["id"] as? Int64
                
                // get primary text
                primaryText = result["name"] as? String
                
                // get image
                if let cover:[String: Any] = result["cover"] as? [String: Any]
                {
                    imageUrl = cover["url"] as? String
                    
                    if let url:String = imageUrl,
                       let imageData:Data = downloadImage(fromUrl: "http:\(url)")
                    {
                        image = UIImage(data: imageData)
                    }
                }
                
                if let i:Int64 = identifier,
                   let t:String = primaryText
                {
                    let result:SearchResult = SearchResult(
                        detailParameters: ["id": String(i)],
                        primaryText: t,
                        secondaryText: nil,
                        image: image ?? MediaType.game.defaultImage
                    )
                    results.append(result)
                }
            }
        }
        
        return results
    }
}
