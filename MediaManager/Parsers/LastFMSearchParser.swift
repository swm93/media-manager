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
class LastFMSearchParser : XMLParser<[SearchResult]>
{
    private let maxResults:Int = 5
    private let imageSizeOrder:[String] = [
        "small",
        "medium",
        "large",
        "extralarge",
        "mega"
    ]
    private let preferredImageSize:String = "medium"

    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist={query}&api_key={api_key}",
            defaultParameters: ["api_key": apiKey],
            requiredParameterNames: ["query"]
        )
        
        super.init(parameterizedUrl)
    }

    
    override internal func objectifyXML(_ rootNode: XMLNode)
    {
        var results:[SearchResult] = [SearchResult]()
        
        if let artistNodes:[XMLNode] = rootNode["results"]?.first?["artistmatches"]?.first?["artist"]
        {
            for artistNode:XMLNode in artistNodes
            {
                var text:String? = nil
                var image:UIImage? = nil
                var imageUrl:String? = nil
                
                text = artistNode["name"]?.first?.value
                
                if let imageNodes:[XMLNode] = artistNode["image"]
                {
                    var sizeUrlMap:[String: String] = [String: String]()
                    var sizeDifference:Int = -1
                    
                    for imageNode:XMLNode in imageNodes
                    {
                        if let size:String = imageNode.attributes["size"]
                        {
                            sizeUrlMap[size] = imageNode.value
                        }
                    }
                    
                    for (size, url) in sizeUrlMap
                    {
                        if (!imageSizeOrder.contains(size))
                        {
                            continue
                        }
                        
                        let newSizeDifference:Int = abs(imageSizeOrder.index(of: size)! - imageSizeOrder.index(of: preferredImageSize)!)
                        
                        if (newSizeDifference < sizeDifference || sizeDifference == -1)
                        {
                            sizeDifference = newSizeDifference
                            imageUrl = url
                        }
                        
                        if (sizeDifference == 0)
                        {
                            break
                        }
                    }
                    
                    if let url:String = imageUrl
                    {
                        image = downloadImage(fromUrl: url)
                    }
                }
                
                if let t:String = text
                {
                    results.append(SearchResult(mediaType: .music, parserType: .lastFM, text: t, image: image))
                }
                
                if (results.count >= maxResults)
                {
                    break
                }
            }
        }
        
        didFinishParsing(results)
    }
}
