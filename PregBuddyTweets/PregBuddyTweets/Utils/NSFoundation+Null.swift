//
//  NSFoundation+Null.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//

import Foundation


extension String{
    
    static func checkIfStringIsNull(forItem item : [String : Any] , key : String) -> String {
        
        var value = ""
        if let fetchedValue = item[key] as? String{
            value = fetchedValue
            if value == "<null>"{
                value = ""
            }
        }
        return value
    }
}


extension NSNumber {
    
    static func checkIfNumberIsNull(forItem item : [String : Any] ,forKey key : String) -> NSNumber{
        
        var number : NSNumber = -1;
        
        if item[key] == nil {
            number = -1;
        }else{
            if item[key] is NSNull {
                number = -1
            }else{
                number = item[key] as! NSNumber
            }
        }
        return number
    }
    
    func toString() -> String {
        return self.stringValue
    }
}

extension Dictionary {
    
    static func ifExists(forItem item: [String : Any] , withKey key : String) -> Bool {
        
        if item[key] == nil {
            return false
        }else{
            return true
        }
    }
}

extension Bool {
    
    static func checkIfBoolIsNull(forItem item : [String : Any] , forKey key : String) -> Bool{
        
        var val : Bool?
        
        if item[key] == nil {
            val = false
        }else{
            if let fetchedValue = item[key] as? Bool {
                val = fetchedValue;
            }else{
                val = false
            }
        }
        return val!
    }
}
