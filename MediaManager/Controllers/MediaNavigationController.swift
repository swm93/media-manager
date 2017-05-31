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
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent
    }
}
