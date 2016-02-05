//
//  APIParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class APIParser : NSObject
{
    internal var searchParameterizedUrl:ParameterizedURL? = nil
    private let completionHandler:(Media?) -> ()
    
    
    init(completionHandler:(Media?) -> ())
    {
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    
    /**
     Fetch data at URL asynchronously and ...
     
     ...
     - returns: ...
     */
    func parse(parameters:[String: String])
    {
        let url:NSURL = getUrl(parameters)
        let session:NSURLSession = NSURLSession.sharedSession()
        let task:NSURLSessionDataTask = session.dataTaskWithURL(url, completionHandler: parse)
        
        task.resume()
        
        print("Parsing URL: \(url)")
    }
    
    
    func didFinishParsing(mediaObject:Media?)
    {
        completionHandler(mediaObject)
    }
    
    
    /**
        Replace parameters in the paramaterized URL with provided values.
        This will throw an exception if the parameterdictionary provided does not contain the required parameters.
     
        - parameter parameters: Mapping of parameter names to the values that they represent.
        - returns: ...
    */
    func getUrl(parameters:[String: String]) -> NSURL
    {
        assert(containsRequiredParameters(parameters, requiredParameters: searchParameterizedUrl!.requiredParameterNames), "All required parameters must be provided")
        
        var url:String = searchParameterizedUrl!.url
        var allParameters:[String: String]
        if let params:[String: String] = searchParameterizedUrl!.defaultParameters
        {
            allParameters = params
            
            for (param, val) in parameters
            {
                allParameters[param] = val
            }
        }
        else
        {
            allParameters = parameters
        }
        
        for (param, val) in allParameters
        {
            let escapedVal:String = val.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            url = url.stringByReplacingOccurrencesOfString("{\(param)}", withString: escapedVal)
        }
        
        return NSURL(string: url)!
    }
    
    
    func downloadImage(urlName:String) -> UIImage?
    {
        var image:UIImage? = nil
        
        if let url:NSURL = NSURL(string: urlName)
        {
            if let data:NSData = NSData(contentsOfURL: url)
            {
                image = UIImage(data: data)
            }
        }
        
        return image
    }
    
    
    // TODO: (Scott) return proper data
    internal func parse(data:NSData?, response:NSURLResponse?, error:NSError?) -> ()
    {
        assert(false, "This method must be overridden")
    }
    

    /**
        Check if a dictionary contains the parameters that are required to populated the paramaterized URL.
    
        - parameter parameters: Mapping of parameter names to the values that they represent.
        - returns: Boolean representing whether the dictionary contains the required parameters.
    */
    private func containsRequiredParameters(parameters:[String: String], requiredParameters:Set<String>) -> Bool
    {
        let parameterNames:Set<String> = Set(parameters.keys)
        return parameterNames.isSupersetOf(requiredParameters)
    }
}