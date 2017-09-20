//
//  MusicDetailTableViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-09-19.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



class MusicDetailTableViewController : MediaDetailTableViewController
{
    @IBOutlet var albumTableViewCell: MediaDetailCell!
    @IBOutlet var artistTableViewCell: MediaDetailCell!
    @IBOutlet var genresTableViewCell: MediaDetailCell!
    @IBOutlet var dateReleasedTableViewCell: MediaDetailCell!
    
    
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let song: SongManaged = self.mediaObject as? SongManaged
        {
            albumTableViewCell.contentLabel.text = song.album?.name
            artistTableViewCell.contentLabel.text = song.album?.artist?.name
            genresTableViewCell.contentLabel.text = song.genres?
                .flatMap({ ($0 as! GenreManaged).name })
                .joined(separator: ", ")
            
            if let dateReleased: Date = song.album?.dateReleased as Date?
            {
                dateReleasedTableViewCell.contentLabel.text = self.dateFormatter.string(from: dateReleased)
            }
        }
    }
}
