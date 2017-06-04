//
//  BookEditTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-06-03.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class BookEditTableViewController : MediaEditTableViewController
{
    @IBOutlet var authorTableViewCell:MediaEditCell!
    @IBOutlet var publisherTableViewCell:MediaEditCell!
    @IBOutlet var genresTableViewCell:MediaEditCell!
    @IBOutlet var datePublishedTableViewCell:MediaEditCell!
}
