//
//  EditTimeCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0


class EditTimeCell : UITableViewCell, EditCell
{
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueButton: UIButton!
    
    var key: String?
    
    var value: Any?
    {
        didSet
        {
            let val: Int = (self.value as? Int) ?? 0
            let timeStr: String = secondsToString(seconds: val / 1000)
            
            self.valueButton.setTitle(timeStr, for: .normal)
        }
    }
    
    
    @IBAction func showTimePicker()
    {
        let (hours, minutes, seconds): (Int, Int, Int) = secondsToHoursMinutesSeconds(seconds: ((self.value as? Int) ?? 0) / 1000)
        let picker: ActionSheetMultipleStringPicker = ActionSheetMultipleStringPicker(
            title: "",
            rows: [
                (0...100).map { String(describing: $0) },
                (0...60).map { String(describing: $0) },
                (0...60).map { String(describing: $0) }
            ],
            initialSelection: [hours, minutes, seconds],
            doneBlock: { (picker: ActionSheetMultipleStringPicker?, values: [Any]?, indexes: Any?) in
                let hours: Int = values?[0] as? Int ?? 0
                let minutes: Int = values?[1] as? Int ?? 0
                let seconds: Int = values?[2] as? Int ?? 0
                
                self.value = ((hours * 60 + minutes) * 60 + seconds) * 1000
                
                if let key: String = self.key
                {
                    self.delegate?.editCellChangedValue(self.value, forKey: key)
                }
            },
            cancel: { (picker: ActionSheetMultipleStringPicker?) in
                return
            },
            origin: self
        )

        picker.show()
    }
}
