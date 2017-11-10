//
//  Photo.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-10.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import NYTPhotoViewer
import UIKit


class Photo : NSObject, NYTPhoto
{
    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString?
    let attributedCaptionCredit: NSAttributedString?
    
    
    convenience init(image: UIImage, title: String? = nil, summary: String? = nil, credit: String? = nil)
    {
        self.init(title: title, summary: summary, credit: credit)
        
        self.image = image
    }
    
    
    convenience init(imageData: Data, title: String? = nil, summary: String? = nil, credit: String? = nil)
    {
        self.init(title: title, summary: summary, credit: credit)
        
        self.imageData = imageData
    }
    
    
    private init(title: String? = nil, summary: String? = nil, credit: String? = nil)
    {
        if let t: String = title
        {
            self.attributedCaptionTitle = NSAttributedString(string: t, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
        else
        {
            self.attributedCaptionTitle = nil
        }
        
        if let s: String = summary
        {
            self.attributedCaptionSummary = NSAttributedString(string: s, attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        }
        else
        {
            self.attributedCaptionSummary = nil
        }
        
        if let c: String = credit
        {
            self.attributedCaptionCredit = NSAttributedString(string: c, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        else
        {
            self.attributedCaptionCredit = nil
        }
        
        super.init()
    }
}
