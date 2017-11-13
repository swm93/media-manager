//
//  ISBNDBSearchParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-11.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class ISBNDBSearchParser: JSONParser<[SearchResult]>
{
    private static let _imageSizes: [String] = [
        "small",
        "medium",
        "large"
    ]
    private let _libraryThingImageUrl: ParameterizedURL
    private let _preferredImageSize: String = ISBNDBSearchParser._imageSizes.first!
    private let _nilImageSizeBytes: Int = 43
    private let _maxResults: Int = 5
    
    
    init(_ apiKey: String, libraryThingApiKey: String)
    {
        let parameterizedUrl: ParameterizedURL = ParameterizedURL(
            url: "http://isbndb.com/api/v2/json/{api_key}/books?q={query}&i={index}",
            defaultParameters: [
                "api_key": apiKey,
                "index": "combined"
            ],
            requiredParameterNames: ["query"]
        )
        self._libraryThingImageUrl = ParameterizedURL(
            url: "http://covers.librarything.com/devkey/{api_key}/{size}/isbn/{isbn}",
            defaultParameters: [
                "api_key": libraryThingApiKey,
                "size": self._preferredImageSize
            ],
            requiredParameterNames: ["isbn"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override func objectifyJSON(_ json: Any) -> [SearchResult]
    {
        var results: [SearchResult] = [SearchResult]()
        
        if let rootObj: [String: Any] = json as? [String: Any],
           let dataObj: [[String: Any]] = rootObj["data"] as? [[String: Any]]
        {
            for resultObj: [String: Any] in dataObj
            {
                var identifier: String? = nil
                var primaryText: String? = nil
                var secondaryText: String? = nil
                var image: UIImage? = nil
                
                // get identifier
                identifier = resultObj["book_id"] as? String
                
                // get primary text
                primaryText = resultObj["title"] as? String
                
                // get secondary text
                if let authorObj: [String: Any] = (resultObj["author_data"] as? [[String: Any]])?.first,
                   let authorName: String = authorObj["name"] as? String
                {
                    secondaryText = authorName
                }
                
                // get image
                if let isbn: String = (resultObj["isbn13"] as? String) ?? (resultObj["isbn10"] as? String)
                {
                    let imageUrl: URL = self._libraryThingImageUrl.resolve(with: ["isbn": isbn])
                    
                    if let imageData: Data = downloadImage(fromUrl: imageUrl.absoluteString)
                    {
                        if (imageData.count > self._nilImageSizeBytes)
                        {
                            image = UIImage(data: imageData)
                        }
                    }
                }
                
                if let i: String = identifier,
                   let t: String = primaryText
                {
                    let result: SearchResult = SearchResult(
                        detailParameters: ["id": i],
                        primaryText: t,
                        secondaryText: secondaryText,
                        image: image ?? MediaType.book.defaultImage
                    )
                    results.append(result)
                }
                
                if (results.count >= self._maxResults)
                {
                    break
                }
            }
        }
        
        return results
    }
}
