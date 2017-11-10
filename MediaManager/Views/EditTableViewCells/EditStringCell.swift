//
//  EditStringCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditStringCell : UITableViewCell, EditCell
{
    typealias ValueType = String
    
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var key: String?
    
    var value: ValueType?
    {
        get
        {
            var result: ValueType? = self.valueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (result == "")
            {
                result = nil
            }
            
            return result
        }
        set
        {
            self.valueTextField.text = newValue
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
