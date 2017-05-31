//
//  ParameterizedURL.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-01-19.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation


struct ParameterizedURL
{
    var url:String
    var defaultParameters:[String: String]?
    var requiredParameterNames:Set<String>
    
    
    /**
     Replace parameters in the paramaterized URL with provided values.
     This will throw an exception if the parameterdictionary provided does not contain the required parameters.
     
     - parameter parameters: Mapping of parameter names to the values that they represent.
     - returns: URL with parameters inserted.
     */
    public func resolve(with parameters:[String: String]) -> URL
    {
        assert(containsRequiredParameters(parameters), "All required parameters must be provided")
        
        var resolvedUrl:String = self.url
        var allParameters:[String: String]
        if let params:[String: String] = defaultParameters
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
            let escapedVal:String = val.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            resolvedUrl = resolvedUrl.replacingOccurrences(of: "{\(param)}", with: escapedVal)
        }
        
        return URL(string: resolvedUrl)!
    }
    
    
    /**
     Check if a dictionary contains the parameters that are required to populated the paramaterized URL.
     
     - parameter parameters: Mapping of parameter names to the values that they represent.
     - returns: Boolean representing whether the dictionary contains the required parameters.
     */
    private func containsRequiredParameters(_ parameters:[String: String]) -> Bool
    {
        let parameterNames:Set<String> = Set(parameters.keys)
        return parameterNames.isSuperset(of: self.requiredParameterNames)
    }
}
