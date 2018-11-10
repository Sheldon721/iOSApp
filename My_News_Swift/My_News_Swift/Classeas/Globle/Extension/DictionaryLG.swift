//
//  DictionaryLG.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/30.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

extension Dictionary {
    
    
    func valueOfInteger(key:Key) -> NSInteger{
        let value = self[key]
        if ((value) == nil) {
            return 0
        }
        return value as! NSInteger
    }
    
    func valueOfInt(key:Key) -> Int {
        
        let value = self[key]
        if((value) == nil){
            return 0
        }
        return value as! Int
    }
    
    func valueOfString(key:Key) -> String {
        let value = self[key]
        if ((value) == nil) {
            return ""
        }
        return value as! String
    }
    
    func valueOfArray(key:Key) -> Array<AnyObject> {
        
        let value = self[key]
        if ((value) == nil) {
            return Array<AnyObject>()
        }
        return value as! Array
        
    }
    
    func valueOffloat(key:Key) -> CGFloat{
        
        let value = self[key]
        if ((value) == nil) {
            return CGFloat()
        }
        return value as! CGFloat
    }
    
    func valueOfBool(key:Key) -> Bool {
        let value = self[key]
        if ((value) == nil) {
            return Bool()
        }
        return value as! Bool
        
    }
    
    func valueOfDict(key:Key) -> Dictionary {
        let value = self[key]
        if ((value) == nil) {
            return Dictionary()
        }
        return value as! Dictionary
    }
    
    
    
}
