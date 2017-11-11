//
//  EditTextCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditTextCell : UITableViewCell, EditCell, UITextViewDelegate
{
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextView: UITextView!
    
    var key: String?
    
    var value: Any?
    {
        get
        {
            var result: String? = self.valueTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (result == "")
            {
                result = nil
            }
            
            return result
        }
        set
        {
            self.valueTextView.text = newValue as? String
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        if let key: String = self.key
        {
            self.delegate?.editCellChangedValue(self.value, forKey: key)
        }
    }
}
