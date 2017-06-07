//
//  LastFMDetailParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-06.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class LastFMDetailParser : JSONParser<ManagedObject>
{
    private let imageSizePreference:[String] = [
        "mega",
        "extralarge",
        "large",
        "medium",
        "small"
    ]
    private let thumbnailSizePreference:[String] = [
        "medium",
        "large",
        "extralarge",
        "mega",
        "small"
    ]
    
    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid={mbid}&api_key={api_key}&format=json",
            defaultParameters: ["api_key": apiKey],
            requiredParameterNames: ["mbid"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override internal func objectifyJSON(_ json: Any) -> ManagedObject
    {
        var result:SongManaged = (self.output as? SongManaged) ?? SongManaged()
        
        if let rootObj:[String: Any] = json as? [String: Any],
           let trackObj:[String: Any] = rootObj["track"] as? [String: Any]
        {
            if let name:String = trackObj["name"] as? String
            {
                result.name = name
            }
            
            if let artistObj:[String: Any] = trackObj["artist"] as? [String: Any],
               let artistName:String = artistObj["name"] as? String
            {
                
            }
            
            if let albumObj:[String: Any] = trackObj["album"] as? [String: Any]
            {
                if let albumName:String = albumObj["name"] as? String
                {
                    
                }
                
                if let albumImageObj:[[String: Any]] = albumObj["image"] as? [[String: Any]]
                {
                    var imageUrl:String? = nil
                    var thumbnailUrl:String? = nil
                    var sizeUrlMap:[String: String] = [String: String]()
                    
                    for iObj:[String: Any] in albumImageObj
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
                    
                    for sizePreference in self.thumbnailSizePreference
                    {
                        if let preferredUrl:String = sizeUrlMap[sizePreference]
                        {
                            thumbnailUrl = preferredUrl
                            break
                        }
                    }
                    
                    if let url:String = imageUrl
                    {
                        result.imageData = downloadImage(fromUrl: url)
                    }
                }
            }
        }
        
        return result
    }
}
