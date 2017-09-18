//
//  APIParser.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-18.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class APIParser<T> : NSObject
{
    public var delegate:ParserDelegate?
    
    internal var parameterizedUrl:ParameterizedURL
    internal var headers:[String: String]?
    
    private var isParsing:Bool = false
    private var completionHandler:((T?) -> ())? = nil
    
    
    init(_ parameterizedUrl:ParameterizedURL, _ headers:[String: String]? = nil)
    {
        self.parameterizedUrl = parameterizedUrl
        self.headers = headers
    }
    
    
    /**
     Fetch data at URL asynchronously and begin parsing it.
     
     - parameter parameters: ...
     - parameter completionHandler: ...
     */
    func parse(_ parameters:[String: String], completionHandler:@escaping (T?) -> ())
    {
        // fetch data at URL asynchronously if we are not already parsing
        if (!isParsing)
        {
            let request:URLRequest = getUrlRequest(parameters)
            fetchData(request, completionHandler: objectifyData)
            
            self.isParsing = true
            self.completionHandler = completionHandler
            
            print("Parsing URL: \(request.url!)")
        }
        // handle error if we are already parsing another URL
        // TODO: handle parse in progress error
        else
        {
            print("ERROR: Can only parse one URL at a time")
        }
    }
    
    
    /**
     Perform completion handler once parsing is complete.
     
     - parameter object: The object that is produced by parsing the data found at URL provided.
    */
    func didFinishParsing(_ result:T?)
    {
        // NOTE: completionHandler is expected to be defined at this point; however if it is not, fail gracefully.
        if let handler:(T?) -> () = completionHandler
        {
            print("Finished Parsing URL: \(self.parameterizedUrl.url)")
            
            handler(result)
        }
        else
        {
            assert(false, "Bad code path; completion handler should be defined")
        }
        
        isParsing = false
        completionHandler = nil
    }
    
    
    internal func objectifyData(_ data:Data?, response:URLResponse?, error:Error?)
    {
        assert(false, "This method must be overridden")
    }
    
    
    internal func downloadImage(fromUrl urlName:String) -> Data?
    {
        var data:Data? = nil
        
        if let url:URL = URL(string: urlName)
        {
            data = try? Data(contentsOf: url)
        }
        
        return data
    }
    
    
    
    private func getUrlRequest(_ parameters:[String: String]) -> URLRequest
    {
        let url:URL = parameterizedUrl.resolve(with: parameters)
        var request:URLRequest = URLRequest(url: url)
        
        if let headers:[String: String] = headers
        {
            for (headerName, value) in headers
            {
                request.addValue(value, forHTTPHeaderField: headerName)
            }
        }
        
        return request
    }
    
    
    private func fetchData(_ request:URLRequest, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void)
    {
        let session:URLSession = URLSession.shared
        let task:URLSessionDataTask = session.dataTask(with: request, completionHandler: completionHandler)
        
        task.resume()
    }
}
