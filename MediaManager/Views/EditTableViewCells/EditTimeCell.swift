//
//  EditTimeCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit


class EditTimeCell : UITableViewCell, EditCell, UIPickerViewDataSource, UIPickerViewDelegate
{
    typealias ValueType = Int
    
    @IBOutlet var delegate: EditCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valuePicker: UIPickerView!
    
    var key: String?
    
    var value: ValueType?
    {
        get
        {
            let hours: Int = self.valuePicker.selectedRow(inComponent: 0)
            let minutes: Int = self.valuePicker.selectedRow(inComponent: 1)
            let seconds: Int = self.valuePicker.selectedRow(inComponent: 2)
            
            return ((hours * 60 + minutes) * 60 + seconds) * 1000
        }
        set
        {
            let val: Int = newValue ?? 0
            let (hours, minutes, seconds): (Int, Int, Int) = secondsToHoursMinutesSeconds(seconds: val / 1000)
            
            self.valuePicker.selectRow(hours, inComponent: 0, animated: true)
            self.valuePicker.selectRow(minutes, inComponent: 1, animated: true)
            self.valuePicker.selectRow(seconds, inComponent: 2, animated: true)
        }
    }
    
    private let _columns: [CountableClosedRange<Int>] = [
        0...100,
        0...60,
        0...60
    ]
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return self._columns.count
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self._columns[component].count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(describing: row)
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if let key: String = self.key
        {
            self.delegate?.editCellChangedValue(self.value, forKey: key)
        }
    }
}
