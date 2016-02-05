//
//  LastFMParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit

//be3b35a76e9315d68bcbb13e3d5a704c
//77efe9e8bc51afe0f1fede54ec4fa0fb
//http://www.last.fm/api/auth?api_key=be3b35a76e9315d68bcbb13e3d5a704c
//http://www.last.fm/api/auth?api_key=77efe9e8bc51afe0f1fede54ec4fa0fb
//http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=ACDC&api_key=be3b35a76e9315d68bcbb13e3d5a704c
class LastFMParser : XMLParser
{
    private let imageSizeOrder:[String: Int] = [
        "small": 0,
        "medium": 1,
        "large": 2,
        "extralarge": 3,
        "mega": 4
    ]
    
    
    override init(completionHandler: (Media?) -> ())
    {
        super.init(completionHandler: completionHandler)
        
        searchParameterizedUrl = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist={query}&api_key={api_key}",
            defaultParameters: nil,
            requiredParameterNames: ["api_key", "query"]
        )
    }

    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        var artist:Artist? = nil
        
        if let artistNode:XMLNode = rootNode[parser]?["artist"]?.first
        {
            artist = Artist()
            
            artist?.name = artistNode["name"]?.first?.value
            artist?.summary = artistNode["bio"]?.first?["content"]?.first?.value
            
            if let imageNodes:[XMLNode] = artistNode["image"]
            {
                var largestSizeIndex:Int = -1;
                var imageUrl:String? = nil
                
                for imageNode:XMLNode in imageNodes
                {
                    if let size:String = imageNode.attributes["size"]
                    {
                        if let sizeIndex:Int = imageSizeOrder[size]
                        {
                            if (sizeIndex > largestSizeIndex)
                            {
                                imageUrl = imageNode.value
                                largestSizeIndex = sizeIndex
                            }
                        }
                    }
                }
                
                if let urlName:String = imageUrl
                {
                    if let image:UIImage = downloadImage(urlName)
                    {
                        artist?.image = image
                    }
                }
            }
            
            if let tagNodes:[XMLNode] = artistNode["tags"]?.first?["tag"]
            {
                for tagNode:XMLNode in tagNodes
                {
                    if let genre:String = tagNode["name"]?.first?.value
                    {
                        artist?.genres.append(genre.capitalizedString)
                    }
                }
            }
        }
        
        parserDidStopDocument(parser, mediaObject: artist)
    }
}