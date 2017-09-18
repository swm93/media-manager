//
//  IGDBDetailParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-03.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class IGDBDetailParser: JSONParser<ManagedMedia>
{
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "https://igdbcom-internet-game-database-v1.p.mashape.com/games/{id}?fields={fields}",
            defaultParameters: [
                "fields": "name,summary,cover,first_release_date"
            ],
            requiredParameterNames: ["id"]
        )
        let headers:[String: String] = [
            "X-Mashape-Key": apiKey,
            "Accept": "application/json"
        ]
        
        super.init(parameterizedUrl, headers)
    }
    
    
    override func objectifyJSON(_ json: Any) -> ManagedMedia
    {
        let result:GameManaged = self.delegate?.getParseResultObject() ?? GameManaged()
        
        if let root:[[String: Any]] = json as? [[String: Any]]
        {
            for resultObj:[String: Any] in root
            {
                // get name
                if let name = resultObj["name"] as? String
                {
                    result.name = name
                }
                
                // get summary
                if let summary = resultObj["summary"] as? String
                {
                    result.summary = summary
                }
                
                // get date released
                if let dateReleased = resultObj["first_release_date"] as? Int64
                {
                    result.dateReleased = NSDate(timeIntervalSince1970: TimeInterval(dateReleased))
                }
                
                // get image
                if let cover:[String: Any] = resultObj["cover"] as? [String: Any]
                {
                    let imageUrl = cover["url"] as? String
                    
                    if let url:String = imageUrl,
                       let imageData:Data = downloadImage(fromUrl: "http:\(url)")
                    {
                        //result.imageData = imageData
                    }
                }
            }
        }
        
        return result
    }
}
