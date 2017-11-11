//
//  EditDateCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0


class EditDateCell : UITableViewCell, EditCell
{
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueButton: UIButton!

    var key: String?
    
    var value: Any?
    {
        didSet
        {
            if let val: Date = self.value as? Date
            {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                
                self.valueButton.setTitle(dateFormatter.string(from: val), for: .normal)
            }
        }
    }
    
    
    @IBAction func showDatePicker()
    {
        let datePicker: ActionSheetDatePicker = ActionSheetDatePicker(
            title: "",
            datePickerMode: .date,
            selectedDate: (self.value as? Date) ?? Date(),
            target: self,
            action: #selector(self.valueChanged),
            origin: self
        )
        
        datePicker.show()
    }
    
    
    @objc func valueChanged(value: Date)
    {
        self.value = value
        
        if let key: String = self.key
        {
            self.delegate?.editCellChangedValue(self.value, forKey: key)
        }
    }
}
