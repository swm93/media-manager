//
//  DebounceUtility.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-09-17.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation


// https://stackoverflow.com/a/40634366/1397470
func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void
{
    var lastFireTime: DispatchTime = DispatchTime.now()
    let dispatchDelay: DispatchTimeInterval = DispatchTimeInterval.milliseconds(interval)
    
    let debouncedFunc: () -> Void = {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay
        
        queue.asyncAfter(deadline: dispatchTime)
        {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now: DispatchTime = DispatchTime.now()
            if (now.rawValue >= when.rawValue)
            {
                action()
            }
        }
    }
    
    return debouncedFunc
}
