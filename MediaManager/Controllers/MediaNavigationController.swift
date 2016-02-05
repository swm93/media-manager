//
//  MediaNavigationController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-01.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class MediaNavigationController : UINavigationController
{
    override func awakeFromNib()
    {
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationBar.shadowImage = UIImage()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}