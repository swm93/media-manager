//
//  EditCell.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-08.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import Foundation
import UIKit



protocol EditCell
{
    associatedtype ValueType
    
    var delegate: EditCellDelegate? { get set }
    
    var key: String? { get set }
    var label: UILabel! { get }
    var value: ValueType? { get set }
}



@objc protocol EditCellDelegate
{
    func editCellChangedValue(_ value: Any?, forKey key: String)
}
