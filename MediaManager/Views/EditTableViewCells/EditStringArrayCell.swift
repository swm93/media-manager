//
//  EditStringArrayCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditStringArrayCell : UITableViewCell, EditCell
{
    typealias ValueType = [String]
    
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var key: String?
    
    var value: ValueType?
    {
        get
        {
            var result: ValueType?
            
            if let strArray: [String.SubSequence] = self.valueTextField.text?.split(separator: ",")
            {
                result = strArray.flatMap()
                    { (subStr: String.SubSequence) in
                        let str: String = String(describing: subStr)
                        var trimmedStr: String? = str.trimmingCharacters(in: .whitespacesAndNewlines)
                        if (trimmedStr == "")
                        {
                            trimmedStr = nil
                        }
                        
                        return trimmedStr
                }
            }
            
            return result
        }
        set
        {
            self.valueTextField.text = newValue?.joined(separator: ", ")
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
