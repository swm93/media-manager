//
//  EditNumberCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditNumberCell : UITableViewCell, EditCell
{
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var key: String?
    
    var value: Any?
    {
        get
        {
            var result: Int?
            let textFieldValue: String? = self.valueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (textFieldValue != nil && textFieldValue != "")
            {
                result = Int(textFieldValue!)
            }
            
            return result
        }
        set
        {
            if let val: Int = newValue as? Int
            {
                self.valueTextField.text = String(describing: val)
            }
        }
    }
    
    
    @IBAction func valueChanged()
    {
        if let key: String = self.key
        {
            self.delegate?.editCellChangedValue(self.value, forKey: key)
        }
    }
}
