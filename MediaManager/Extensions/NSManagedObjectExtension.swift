//
//  NSManagedObjectExtension.swift
//  MediaManager
//
//  Created by Scott Mielcarski on 2017-11-09.
//  Copyright © 2017 Scott Mielcarski. All rights reserved.
//

import CoreData
import Foundation


extension NSManagedObject
{
    public func value(for key: String) -> Any?
    {
        var result: Any?
        
        if (key.contains("."))
        {
            result = self.value(forKeyPath: key)
        }
        else
        {
            result = self.value(forKey: key)
        }
        
        return result
    }
    
    
    public func setValue(_ value: Any?, for key: String)
    {
        if (key.contains("."))
        {
            self.setValue(value, forKeyPath: key)
        }
        else
        {
            self.setValue(value, forKey: key)
        }
    }
    
    
    public func getString(forKey key: String) -> String?
    {
        let value: Any? = self.value(forKey: key)
        
        return self.toString(value)
    }
    
    
    public func getString(forKeyPath keyPath: String) -> String?
    {
        let value: Any? = self.value(forKeyPath: keyPath)
        
        return self.toString(value)
    }
    
    
    public func setString(_ value: String, forKey key: String)
    {
        let oldValue: Any? = self.value(forKey: key)
        let newValue: Any? = self.fromString(value, oldValue: oldValue)
        
        self.setValue(newValue, forKey: key)
    }
    
    
    public func setString(_ value: String, forKeyPath keyPath: String)
    {
        let oldValue: Any? = self.value(forKeyPath: keyPath)
        let newValue: Any? = self.fromString(value, oldValue: oldValue)
        
        self.setValue(newValue, forKeyPath: keyPath)
    }
    
    
    private func toString(_ value: Any?) -> String?
    {
        var result: String?
        
        switch (value)
        {
        case let v as String:
            result = v
            
        case let v as Int:
            result = String(v)
            
        case let v as Float:
            result = String(v)
            
        case let v as Double:
            result = String(v)
            
        case let v as Date:
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            result = dateFormatter.string(from: v)
            
        default:
            print("Unable to convert to string; unhandled type: \(value.debugDescription)")
        }
        
        return result
    }
    
    
    private func fromString(_ value: String, oldValue: Any?) -> Any?
    {
        var result: Any?
        
        switch (oldValue)
        {
        case is String:
            result = value
            
        case is Int:
            result = Int(value)
            
        case is Float:
            result = Float(value)
            
        case is Double:
            result = Double(value)
            
        case is Date:
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            result = dateFormatter.date(from: value)
            
        default:
            print("Unable to convert from string; unhandled type: \(value.debugDescription)")
        }
        
        return result
    }
}
