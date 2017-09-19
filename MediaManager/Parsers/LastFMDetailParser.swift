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


class LastFMDetailParser : JSONParser<ManagedMedia>
{
    private let imageSizePreference:[String] = [
        "mega",
        "extralarge",
        "large",
        "medium",
        "small"
    ]
    
    
    init(_ apiKey:String)
    {
        let parameterizedUrl:ParameterizedURL = ParameterizedURL(
            url: "http://ws.audioscrobbler.com/2.0/?method=track.getinfo&mbid={mbid}&api_key={api_key}&format=json",
            defaultParameters: ["api_key": apiKey],
            requiredParameterNames: ["mbid"]
        )
        
        super.init(parameterizedUrl)
    }
    
    
    override internal func objectifyJSON(_ json: Any) -> ManagedMedia
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let result:SongManaged = self.delegate?.getParseResultObject() ?? SongManaged(context: appDelegate.persistentContainer.viewContext)
        
        if let rootObj:[String: Any] = json as? [String: Any],
           let trackObj:[String: Any] = rootObj["track"] as? [String: Any]
        {
            if let name:String = trackObj["name"] as? String
            {
                result.name = name
            }
            
            if let durationStr: String = trackObj["duration"] as? String,
               let duration: Int = Int(durationStr)
            {
                result.duration = NSNumber(value: duration)
            }
            
            if let albumObj:[String: Any] = trackObj["album"] as? [String: Any],
               let albumName:String = albumObj["title"] as? String,
               let artistObj:[String: Any] = trackObj["artist"] as? [String: Any],
               let artistName:String = artistObj["name"] as? String
            {
                let albums: [AlbumManaged] = ManagedObjectManager.getBy(
                    fetchRequest: AlbumManaged.fetchRequest(),
                    attribute: "name",
                    value: albumName
                )
                var album: AlbumManaged? = albums.first(where: {
                    return $0.artist?.name == artistName
                })
                
                if (album == nil)
                {
                    album = AlbumManaged(context: appDelegate.persistentContainer.viewContext)
                    
                    album!.name = albumName
                    
                    if let releaseDate: String = albumObj["releasedate"] as? String
                    {
                        let releaseDateFormatter: DateFormatter = DateFormatter()
                        releaseDateFormatter.dateFormat = "d MMM yyyy, HH:mm"
                        
                        let date: NSDate? = releaseDateFormatter.date(from: releaseDate) as NSDate?
                        result.album?.dateReleased = date
                    }
                    
                    if let albumImageObj:[[String: Any]] = albumObj["image"] as? [[String: Any]]
                    {
                        let albumImageUrl: String = self.findPreferredImageUrl(albumImageObj)
                        
                        if let data: Data = downloadImage(fromUrl: albumImageUrl)
                        {
                            album!.imageData = NSData(data: data)
                        }
                    }
                    
                    let artists: [ArtistManaged] = ManagedObjectManager.getBy(
                        fetchRequest: ArtistManaged.fetchRequest(),
                        attribute: "name",
                        value: artistName
                    )
                    var artist: ArtistManaged? = artists.first
                    
                    if (artist == nil)
                    {
                        artist = ArtistManaged(context: appDelegate.persistentContainer.viewContext)
                        
                        artist!.name = artistName
                        
                        if let artistImageObj:[[String: Any]] = artistObj["image"] as? [[String: Any]]
                        {
                            let artistImageUrl: String = self.findPreferredImageUrl(artistImageObj)
                            
                            if let data: Data = downloadImage(fromUrl: artistImageUrl)
                            {
                                artist!.imageData = NSData(data: data)
                            }
                        }
                        
                        album!.artist = artist
                    }
                    
                    if let topTagsObj: [String: Any] = trackObj["toptags"] as? [String: Any],
                       let tagsObj: [[String: Any]] = topTagsObj["tag"] as? [[String: Any]]
                    {
                        let lowerArtistName: String = artistName.lowercased()
                        let lowerAlbumName: String = albumName.lowercased()
                        
                        for tagObj in tagsObj
                        {
                            if let tagName: String = tagObj["name"] as? String
                            {
                                let lowerTagName: String = tagName.lowercased()
                                
                                if (lowerTagName != lowerAlbumName && lowerTagName != lowerArtistName)
                                {
                                    let genreFetchRequest: NSFetchRequest = GenreManaged.fetchRequest()
                                    genreFetchRequest.predicate = NSPredicate(format: "%K = %@", "name", tagName)
                                    
                                    let genres: [GenreManaged] = ManagedObjectManager.fetch(genreFetchRequest)
                                    var genre: GenreManaged? = genres.first
                                    
                                    if (genre == nil)
                                    {
                                        genre = GenreManaged(context: appDelegate.persistentContainer.viewContext)
                                        genre!.name = tagName
                                    }
                                    
                                    album!.addToGenres(genre!)
                                }
                            }
                        }
                    }
                }
                
                result.album = album
            }
        }
        
        return result
    }
    
    
    private func findPreferredImageUrl(_ imageUrls: [[String: Any]]) -> String
    {
        var imageUrl: String? = nil
        var sizeUrlMap: [String: String] = [String: String]()
        
        for imageObj: [String: Any] in imageUrls
        {
            if let size: String = imageObj["size"] as? String,
               let url: String = imageObj["#text"] as? String
            {
                sizeUrlMap[size] = url
            }
        }
        
        for sizePreference in self.imageSizePreference
        {
            if let preferredUrl: String = sizeUrlMap[sizePreference]
            {
                imageUrl = preferredUrl
                break
            }
        }
        
        if (imageUrl == nil)
        {
            imageUrl = sizeUrlMap.first?.value
        }
        
        return imageUrl!
    }
}
