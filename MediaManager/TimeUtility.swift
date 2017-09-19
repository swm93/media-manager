//
//  TimeUtility.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-09-17.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation



func secondsToHoursMinutesSeconds(seconds: Int) -> (h: Int, m: Int, s: Int)
{
    return (h: seconds / 3600, m: (seconds % 3600) / 60, s: (seconds % 3600) % 60)
}


func secondsToString(seconds: Int) -> String
{
    var result: String = ""
    let hms: (h: Int, m: Int, s: Int) = secondsToHoursMinutesSeconds(seconds: seconds)
    
    if (hms.h > 0)
    {
        result += String(format: "%02d:", hms.h)
    }
    
    result += String(format: "%02d:%02d", hms.m, hms.s)
    
    return result
}
