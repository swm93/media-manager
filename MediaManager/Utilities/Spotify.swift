//
//  Spotify.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-08.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import SafariServices
import UIKit


class Spotify : NSObject, SPTAudioStreamingDelegate
{
    static let shared: Spotify = Spotify()
    
    private let _authUrl: URL = URL(string: "mediamanager://spotifyauth")!
    private let _sessionKey: String = "current_session"
    
    private var _auth: SPTAuth!
    private var _player: SPTAudioStreamingController?
    private var _authViewController: UIViewController?
    private var _authCallback: ((SPTSession) -> ())?
    
    private var _songUri: String?
    
    
    
    private override init()
    {
        super.init()
        
        self._auth = SPTAuth.defaultInstance()
        self._player = SPTAudioStreamingController.sharedInstance()
        
        self._auth.clientID = PListManager("Secrets")["spotify_client_id"] as! String
        self._auth.redirectURL = self._authUrl
        self._auth.sessionUserDefaultsKey = self._sessionKey
        self._auth.requestedScopes = [SPTAuthStreamingScope]
        
        self._player?.delegate = self
        
        do
        {
            try self._player?.start(withClientId: self._auth.clientID)
        }
        catch
        {
            assert(false, "There was a problem starting the Spotify SDK")
        }
    }
    
    
    public func play(uri: String)
    {
        self._songUri = uri
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.authenticate()
            { (session: SPTSession) in
                self._player?.login(withAccessToken: session.accessToken)
            }
        }
    }
    
    
    public func search(query: String, complete: ((URL) -> ())?)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            self.authenticate()
            { (session: SPTSession) in
                SPTSearch.perform(withQuery: query, queryType: .queryTypeTrack, accessToken: session.accessToken)
                { (error: Error?, result: Any?) in
                    if let page: SPTListPage = result as? SPTListPage
                    {
                        for item: Any in page.items
                        {
                            if let track: SPTPartialTrack = item as? SPTPartialTrack
                            {
                                if (track.isPlayable)
                                {
                                    complete?(track.playableUri)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    public func canHandle(_ url: URL) -> Bool
    {
        return self._auth.canHandle(url)
    }
    
    
    public func respond(to url: URL)
    {
        assert(self.canHandle(url), "Unable to handle url: \(url)")
        
        self._authViewController?.presentingViewController?.dismiss(animated: true)
        self._authViewController = nil
        
        self._auth.handleAuthCallback(withTriggeredAuthURL: url)
        { [unowned self] (error: Error?, session: SPTSession?) in
            if let s: SPTSession = session
            {
                self._authCallback?(s)
            }
            else if let e: Error = error
            {
                print("Spotify failed to authenticate: \(e)")
            }
        }
    }
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!)
    {
        audioStreaming.playSpotifyURI(self._songUri, startingWith: 0, startingWithPosition: 0)
        { (error: Error?) in
            if (error != nil)
            {
                print("Spotify failed to play: \(error!)")
            }
        }
    }
    
    
    private func authenticate(complete: ((SPTSession) -> ())?)
    {
        if (!(self._auth.session?.isValid() ?? false))
        {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let authUrl: URL = self._auth.spotifyWebAuthenticationURL()
            
            self._authViewController = SFSafariViewController(url: authUrl)
            appDelegate.window?.rootViewController?.present(self._authViewController!, animated: true)
            
            self._authCallback = complete
        }
        else
        {
            complete?(self._auth.session)
        }
    }
}
