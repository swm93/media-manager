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
}