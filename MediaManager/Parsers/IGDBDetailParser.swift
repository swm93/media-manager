//
//  IGDBDetailParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-03.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class IGDBDetailParser: JSONParser<ManagedObject>
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
    
    
    override func objectifyJSON(_ json: Any) -> ManagedObject
    {
        assert(false, "This method is not implemented")
    }
}
