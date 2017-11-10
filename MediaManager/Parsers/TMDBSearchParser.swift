//
//  TMDBSearchParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-04.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class TMDBSearchParser: JSONParser<[SearchResult]>
{
    private let _maxResults: Int = 5
    private let _imageBaseUrl: String = "http://image.tmdb.org/t/p/w185/"
    private let _imageSizes: [String] = [
        "w92",
        "w154",
        "w185",
        "w342",
        "w500",
        "w780",
        "original"
    ]
    private let _preferredImageSize: String = "w185"
    
    
    
    //https://api.themoviedb.org/3/search/movie?api_key=API_KEY&query=simpsons&page=1
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "https://api.themoviedb.org/3/search/movie?api_key={api_key}&query={query}&page={page}",
            defaultParameters: [
                "api_key": apiKey,
                "page": "1"
            ],
            requiredParameterNames: ["query"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override func objectifyJSON(_ json: Any) -> [SearchResult]
    {
        var results: [SearchResult] = [SearchResult]()
        
        if let root: [String: Any] = json as? [String: Any],
           let jsonResults: [[String: Any]] = root["results"] as? [[String: Any]]
        {
            for jsonResult: [String: Any] in jsonResults
            {
                var identifier: String? = nil
                let text: String? = jsonResult["title"] as? String
                var image: UIImage? = nil
                
                if let id: Int = jsonResult["id"] as? Int
                {
                    identifier = String(id)
                }
                
                if let relImagePath: String = jsonResult["poster_path"] as? String,
                   let imageData: Data = downloadImage(fromUrl: "\(self._imageBaseUrl)\(relImagePath)")
                {
                    image = UIImage(data: imageData)
                }
                
                if let i: String = identifier,
                   let t: String = text
                {
                    let result:SearchResult = SearchResult(
                        detailParameters: ["id": i],
                        primaryText: t,
                        secondaryText: nil,
                        image: image ?? MediaType.movie.defaultImage
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
