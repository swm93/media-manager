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
    @IBOutlet var albumTableViewCell: MediaEditCell!
    @IBOutlet var artistTableViewCell: MediaEditCell!
    @IBOutlet var genresTableViewCell: MediaEditCell!
    @IBOutlet var releaseDateTableViewCell: MediaEditCell!
    
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let song: SongManaged = self.mediaObject as? SongManaged
        {
            albumTableViewCell.textField.text = song.album?.name
            artistTableViewCell.textField.text = song.album?.artist?.name
            genresTableViewCell.textField.text = song.genres?
                .flatMap({ ($0 as! GenreManaged).name })
                .joined(separator: ", ")
            
            if let dateReleased: Date = song.album?.dateReleased as Date?
            {
                releaseDateTableViewCell.textField.text = self.dateFormatter.string(from: dateReleased)
            }
        }
    }
}
