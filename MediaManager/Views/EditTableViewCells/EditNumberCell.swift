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
    typealias ValueType = Int
    
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var key: String?
    
    var value: ValueType?
    {
        get
        {
            var result: ValueType?
            let textFieldValue: String? = self.valueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (textFieldValue != nil && textFieldValue != "")
            {
                result = ValueType(textFieldValue!)
            }
            
            return result
        }
        set
        {
            if let val: ValueType = newValue
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
