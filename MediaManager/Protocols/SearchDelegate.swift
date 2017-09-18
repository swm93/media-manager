//
//  SearchDelegate.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-01.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation



protocol SearchDelegate
{
    func fetchSearchResults(_ query:String, completionHandler:@escaping ([SearchResult]?) -> Void)
    func fetchDetailResult(_ searchResult:SearchResult, completionHandler:@escaping (ManagedMedia?) -> Void)
}
