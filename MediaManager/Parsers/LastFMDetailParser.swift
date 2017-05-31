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


class LastFMDetailParser : XMLParser<ManagedObject>
{
    private let imageSizeOrder:[String] = [
        "small",
        "medium",
        "large",
        "extralarge",
        "mega"
    ]
    private let preferredImageSizes:[String: String] = [
        "image": "mega",
        "thumbnail": "medium"
    ]
    
    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist={query}&api_key={api_key}",
            defaultParameters: ["api_key": apiKey],
            requiredParameterNames: ["query"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override internal func objectifyXML(_ rootNode: XMLNode)
    {
        var results:[ArtistManaged] = [ArtistManaged]()
        
        if let artistNode:XMLNode = rootNode["artist"]?.first
        {
            let artist:ArtistManaged = ArtistManaged()
            
            if let name:String = artistNode["name"]?.first?.value
            {
                artist.name = name
            }
            if let summary:String = artistNode["bio"]?.first?["content"]?.first?.value
            {
                artist.summary = summary
            }
            
            if let tagNodes:[XMLNode] = artistNode["tags"]?.first?["tag"]
            {
                for tagNode:XMLNode in tagNodes
                {
                    if let genreName:String = tagNode["name"]?.first?.value
                    {
                        let genre:GenreManaged = GenreManaged()
                        genre.name = genreName.capitalized

                        artist.addGenre(genre)
                    }
                }
            }
            
            if let imageNodes:[XMLNode] = artistNode["image"]
            {
                var urls:[String: String?] = ["image": nil, "thumbnail": nil]
                var sizeUrlMap:[String: String] = [String: String]()
                var sizeDiffs:[String: Int] = ["image": -1, "thumbnail": -1]
                
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
                    
                    for (type, preferredSize) in preferredImageSizes
                    {
                        let newSizeDiff:Int = abs(imageSizeOrder.index(of: size)! - imageSizeOrder.index(of: preferredSize)!)
                        
                        if (newSizeDiff < sizeDiffs[type]! || sizeDiffs[type]! == -1)
                        {
                            sizeDiffs[type] = newSizeDiff
                            urls[type] = url
                        }
                    }
                    
                    if (sizeDiffs["image"]! == 0 && sizeDiffs["thumbnail"]! == 0)
                    {
                        break
                    }
                }
                
                for (type, url) in urls
                {
                    if let u:String = url
                    {
                        if let image:UIImage = downloadImage(fromUrl: u)
                        {
                            if let imageData:Data = UIImagePNGRepresentation(image)
                            {
                                if (type == "image")
                                {
                                    artist.imageData = imageData
                                }
                                else if (type == "thumbnail")
                                {
                                    artist.thumbnail = imageData
                                }
                            }
                        }
                    }
                }
            }
            
            results.append(artist)
        }
        
        didFinishParsing(results)
    }
}
