//
//  LastFMSearchParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit

//http://www.last.fm/api/auth?api_key=API_KEY
//http://www.last.fm/api/auth?api_key=API_KEY
//http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=ACDC&api_key=API_KEY
class LastFMSearchParser : JSONParser<[SearchResult]>
{
    private let imageSizePreference:[String] = [
        "medium",
        "large",
        "extralarge",
        "mega",
        "small"
    ]

    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=track.search&track={query}&api_key={api_key}&limit={limit}&page={page}&format=json",
            defaultParameters: [
                "api_key": apiKey,
                "page": "0",
                "limit": "5"
            ],
            requiredParameterNames: ["query"]
        )
        
        super.init(parameterizedUrl)
    }

    
    override internal func objectifyJSON(_ json: Any) -> [SearchResult]
    {
        var results:[SearchResult] = [SearchResult]()
        
        if let rootObj:[String: Any] = json as? [String: Any]
        {
            if let resultsObj:[String: Any] = rootObj["results"] as? [String: Any],
               let trackMatchesObj:[String: [Any]] = resultsObj["trackmatches"] as? [String: [Any]],
                let trackObj:[[String: Any]] = trackMatchesObj["track"] as? [[String: Any]]
            {
                for tObj:[String: Any] in trackObj
                {
                    var identifier:String? = nil
                    var primaryText:String? = nil
                    var secondaryText:String? = nil
                    var image:UIImage? = nil
                    var imageUrl:String? = nil
                    
                    // get identifier
                    identifier = tObj["mbid"] as? String
                    if (identifier == "")
                    {
                        identifier = nil
                    }
                    
                    // get primary text
                    primaryText = tObj["name"] as? String
                    if (primaryText == "")
                    {
                        primaryText = nil
                    }
                    
                    // get secondary text
                    secondaryText = tObj["artist"] as? String
                    
                    // get image
                    if let imageObj:[[String: Any]] = tObj["image"] as? [[String: Any]]
                    {
                        var sizeUrlMap:[String: String] = [String: String]()
                        
                        for iObj:[String: Any] in imageObj
                        {
                            if let size:String = iObj["size"] as? String,
                               let url:String = iObj["#text"] as? String
                            {
                                sizeUrlMap[size] = url
                            }
                        }
                        
                        for sizePreference in self.imageSizePreference
                        {
                            if let preferredUrl:String = sizeUrlMap[sizePreference]
                            {
                                imageUrl = preferredUrl
                                break
                            }
                        }
                        
                        if let url:String = imageUrl,
                           let imageData:Data = downloadImage(fromUrl: url)
                        {
                            image = UIImage(data: imageData)
                        }
                    }
                    
                    if let i:String = identifier,
                       let t:String = primaryText
                    {
                        let result:SearchResult = SearchResult(
                            detailParameters: ["mbid": i],
                            primaryText: t,
                            secondaryText: secondaryText,
                            image: image ?? MediaType.music.defaultImage
                        )
                        results.append(result)
                    }
                }
            }
        }
        
        return results
    }
}
