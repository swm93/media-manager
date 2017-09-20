//
//  BookDetailTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-09-19.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class BookDetailTableViewController : MediaDetailTableViewController
{
    @IBOutlet var authorTableViewCell: MediaDetailCell!
    @IBOutlet var publisherTableViewCell: MediaDetailCell!
    @IBOutlet var genresTableViewCell: MediaDetailCell!
    @IBOutlet var datePublishedTableViewCell: MediaDetailCell!
}
