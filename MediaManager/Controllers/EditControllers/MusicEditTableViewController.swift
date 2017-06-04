//
//  MusicEditTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-03.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class MusicEditTableViewController : MediaEditTableViewController
{
    @IBOutlet var albumTableViewCell:MediaEditCell!
    @IBOutlet var artistTableViewCell:MediaEditCell!
    @IBOutlet var genresTableViewCell:MediaEditCell!
    @IBOutlet var releaseDateTableViewCell:MediaEditCell!
}
