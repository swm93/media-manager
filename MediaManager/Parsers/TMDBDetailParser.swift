//
//  TMDBDetailParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-11.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class TMDBDetailParser : JSONParser<ManagedMedia>
{
    private let _imageBaseUrl: String = "http://image.tmdb.org/t/p/"
    private static let _imageSizes: [String] = [
        "w92",
        "w154",
        "w185",
        "w342",
        "w500",
        "w780",
        "original"
    ]
    private let _preferredImageSize: String = TMDBDetailParser._imageSizes.last!
    private var _dateFormatter: DateFormatter = DateFormatter()
    
    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "https://api.themoviedb.org/3/movie/{id}?api_key={api_key}",
            defaultParameters: ["api_key": apiKey],
            requiredParameterNames: ["id"]
        )
        
        self._dateFormatter.dateFormat = "yyyy-MM-dd"
        
        super.init(parameterizedUrl)
    }
    
    
    override internal func objectifyJSON(_ json: Any) -> ManagedMedia
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let result: MovieManaged = self.delegate?.getParseResultObject() ?? MovieManaged(context: appDelegate.persistentContainer.viewContext)
        
        if let rootObj:[String: Any] = json as? [String: Any]
        {
            if let title: String = rootObj["title"] as? String
            {
                result.name = title
            }
            
            if let durationStr: String = rootObj["runtime"] as? String,
               let durationMin: Int = Int(durationStr)
            {
                result.duration = NSNumber(value: durationMin * 60 * 1000)
            }
            
            if let budgetStr: String = rootObj["budget"] as? String,
               let budget: Int = Int(budgetStr)
            {
                //result.budget = NSNumber(value: budget)
            }
            
            if let revenueStr: String = rootObj["revenue"] as? String,
               let revenue: Int = Int(revenueStr)
            {
                //result.revenue = NSNumber(value: revenue)
            }
            
            if let overview: String = rootObj["overview"] as? String
            {
                result.plot = overview
            }
            
            if let releaseDateStr: String = rootObj["release_date"] as? String,
               let releaseDate: Date = self._dateFormatter.date(from: releaseDateStr)
            {
                result.dateReleased = releaseDate
            }
            
            if let relImagePath: String = rootObj["poster_path"] as? String,
               let imageData: Data = downloadImage(fromUrl: "\(self._imageBaseUrl)/\(self._preferredImageSize)\(relImagePath)")
            {
                result.imageData = imageData
            }
            
            if let genresObj: [[String: Any]] = rootObj["genres"] as? [[String: Any]]
            {
                for genreObj: [String: Any] in genresObj
                {
                    if let genreName: String = genreObj["name"] as? String
                    {
                        let genreFetchRequest: NSFetchRequest = GenreManaged.fetchRequest()
                        genreFetchRequest.predicate = NSPredicate(format: "%K = %@", "name", genreName)
                        
                        let genres: [GenreManaged] = ManagedObjectManager.fetch(genreFetchRequest)
                        var genre: GenreManaged? = genres.first
                        
                        if (genre == nil)
                        {
                            genre = GenreManaged(context: appDelegate.persistentContainer.viewContext)
                            genre!.name = genreName
                        }
                        
                        result.addToGenres(genre!)
                    }
                }
            }
        }
        
        return result
    }
}
