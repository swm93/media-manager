//
//  EditDateCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditDateCell : UITableViewCell, EditCell
{
    typealias ValueType = Date
    
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueDatePicker: UIDatePicker!
    
    var key: String?
    
    var value: ValueType?
    {
        get
        {
            return self.valueDatePicker.date
        }
        set
        {
            if let date: Date = newValue
            {
                self.valueDatePicker.date = date
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
