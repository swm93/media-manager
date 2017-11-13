//
//  ISBNDBDetailParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-12.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ISBNDBDetailParser : JSONParser<ManagedMedia>
{
    private static let _imageSizes: [String] = [
        "small",
        "medium",
        "large"
    ]
    private let _libraryThingImageUrl: ParameterizedURL
    private let _preferredImageSize: String = ISBNDBDetailParser._imageSizes.last!
    private let _nilImageSizeBytes: Int = 43
    private var _dateFormatter: DateFormatter = DateFormatter()
    
    
    init(_ apiKey: String, libraryThingApiKey: String)
    {
        let parameterizedUrl: ParameterizedURL = ParameterizedURL(
            url: "http://isbndb.com/api/v2/json/{api_key}/book/{id}",
            defaultParameters: [
                "api_key": apiKey,
                "index": "combined"
            ],
            requiredParameterNames: ["id"]
        )
        self._libraryThingImageUrl = ParameterizedURL(
            url: "http://covers.librarything.com/devkey/{api_key}/{size}/isbn/{isbn}",
            defaultParameters: [
                "api_key": libraryThingApiKey,
                "size": self._preferredImageSize
            ],
            requiredParameterNames: ["isbn"]
        )
        
        self._dateFormatter.dateFormat = "yyyy-MM-dd"
        
        super.init(parameterizedUrl)
    }
    
    
    override internal func objectifyJSON(_ json: Any) -> ManagedMedia
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let result: BookManaged = self.delegate?.getParseResultObject() ?? BookManaged(context: appDelegate.persistentContainer.viewContext)
        
        if let rootObj: [String: Any] = json as? [String: Any],
           let dataObj: [String: Any] = (rootObj["data"] as? [[String: Any]])?.first
        {
            result.name = dataObj["title"] as? String
            result.plot = dataObj["summary"] as? String
            //result.isbn = (dataObj["isbn13"] as? String) ?? (dataObj["isbn10"] as? String)
            
            if let authorObj: [String: Any] = (dataObj["author_data"] as? [[String: Any]])?.first,
               let authorName: String = authorObj["name"] as? String
            {
                let authors: [AuthorManaged] = ManagedObjectManager.getBy(
                    fetchRequest: AuthorManaged.fetchRequest(),
                    attribute: "name",
                    value: authorName
                )
                var author: AuthorManaged? = authors.first
                
                if (author == nil)
                {
                    author = AuthorManaged(context: appDelegate.persistentContainer.viewContext)
                    author!.name = authorName
                }
                
                result.addToAuthors(author!)
            }
            
//            if let publisherName: String = dataObj["publisher_name"] as? String
//            {
//                let publishers: [Publishermanaged] = ManagedObjectManager.getBy(
//                    fetchRequest: PublisherManaged.fetchRequest(),
//                    attribute: "name",
//                    value: publisherName
//                )
//                var publisher: PublisherManaged? = publishers.first
//
//                if (publisher == nil)
//                {
//                    publisher = PublisherManaged(context: appDelegate.persistentContainer.viewContext)
//                    publisher!.name = publisherName
//                }
//
//                result.addToPublishers(publisher!)
//            }
            
            // get image
            if let isbn: String = (dataObj["isbn13"] as? String) ?? (dataObj["isbn10"] as? String)
            {
                let imageUrl: URL = self._libraryThingImageUrl.resolve(with: ["isbn": isbn])
                let imageData: Data? = self.downloadImage(fromUrl: imageUrl.absoluteString)
                
                if ((imageData?.count ?? 0) > self._nilImageSizeBytes)
                {
                    result.imageData = imageData
                }
            }
        }
        
        return result
    }
}
