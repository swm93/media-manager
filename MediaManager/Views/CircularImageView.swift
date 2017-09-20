//
//  CircularImageView.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2016-02-01.
//  Copyright © 2016 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class CircularImageView : UIImageView
{
    @IBInspectable var borderWidth:CGFloat
    {
        get
        {
            return layer.borderWidth
        }
        set
        {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor:UIColor?
    {
        get
        {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set
        {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    override var image: UIImage?
    {
        willSet(newValue)
        {
            if let size: CGSize = newValue?.size
            {
                var contentMode: UIViewContentMode
                
                if (size.width < self.frame.width && size.height < self.frame.height)
                {
                    contentMode = .center
                }
                else
                {
                    contentMode = .scaleAspectFill
                }
                
                self.contentMode = contentMode
            }
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        layer.cornerRadius = min(frame.height, frame.width) / 2
        layer.masksToBounds = true
    }
}
