//
//  MediaDetailControlsViewController.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-08.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class MediaDetailControlsViewController : UIViewController
{
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    public var mediaObject: ManagedMedia!
    
    private let _buttonSpacing: CGFloat = 8
    
    private var _spotifyUri: String?
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let view: UIStackView = widthConstraint.firstItem as! UIStackView
        let buttonWidth: CGFloat = self.view.frame.height
        let buttonCount: Int = view.subviews.count
        self.widthConstraint.constant = (CGFloat(buttonCount) * buttonWidth) + (CGFloat(buttonCount - 1) * self._buttonSpacing)
    }
    
    @IBAction public func playOnSpotify()
    {
        if let song: SongManaged = mediaObject as? SongManaged
        {
            if let uri: String = self._spotifyUri
            {
                Spotify.shared.play(uri: uri)
            }
            else
            {
                if var query: String = song.name
                {
                    if let artistName: String = song.album?.artist?.name
                    {
                        query.append(" \(artistName)")
                    }
                    
                    Spotify.shared.search(query: query)
                    { (uri: URL) in
                        self._spotifyUri = uri.absoluteString
                        Spotify.shared.play(uri: uri.absoluteString)
                    }
                }
            }
        }
    }
    
    @IBAction public func findOnLastFM()
    {
        
    }
}
