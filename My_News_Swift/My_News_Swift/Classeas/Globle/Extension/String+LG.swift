//
//  String+LG.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

extension String {
    
    func sizeToFots(labelStr:String,font:UIFont,width:CGFloat,height:CGFloat) -> CGSize {
        
        let statusLabelText: NSString = labelStr as NSString
        
        
        let size = CGSize.init(width: width, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context:nil).size
        
        return strSize
    }
    
    
//    func converTime(time : NSInteger) -> String {
//        
//        
//        
//        let fmt = DateFormatter()
//        let d = Date.init(timeIntervalSince1970: TimeInterval(time))
//        if time / 3600 >= 1 {
//            fmt.date(from: "HH:mm:ss")
//        } else {
//            fmt.date(from: "mm:ss")
//        }
//        
//        let timeStr = fmt.string(from: d)
//        
//        return timeStr
//    }
}

