//
//  GameDetailTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-09-19.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class GameDetailTableViewController : MediaDetailTableViewController
{
    @IBOutlet var platformsTableViewCell: MediaDetailCell!
    @IBOutlet var genresTableViewCell: MediaDetailCell!
    @IBOutlet var dateReleasedTableViewCell: MediaDetailCell!
}
