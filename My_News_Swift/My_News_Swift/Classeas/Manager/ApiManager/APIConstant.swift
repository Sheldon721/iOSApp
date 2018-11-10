//
//  APIConstant.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import Foundation

// MARK: -  W  H

let Kwidth = UIScreen.main.bounds.size.width

let Kheight = UIScreen.main.bounds.size.height


let iphone6_plus = Kheight == 736

let iphone6 = Kheight == 667

let iphone5 = Kheight == 568

let iphone6_later = Kheight >= 667

// 152
let kExpandHeaderViewHeight = Kheight >= 667 ? 190 : 138


let MeCollecTionHeight = CGFloat(iphone6_later ? 70 : 60)

let MeCollectionCornerRadius = CGFloat(iphone6_later ? 35.0 : 30.0)

let padding = CGFloat(5)

let doublePadding = CGFloat(10)

let twoDoublePadding = CGFloat(20)

func fontSize(key: Int) -> UIFont? {
    return UIFont.systemFont(ofSize: CGFloat(key))
}

func arc4randomColor() -> UIColor? {
    return UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
}

let translucenceColor = UIColor.init(white: 0, alpha: 0.5)

let appkey = "ed71870b7a07761f4400e0b85557db01"

let kApiHttpURL = "http://v.juhe.cn/toutiao/index?"


let qqApiKey = "KEYLg66Zu6IvCFaPtYo"

let qqAppleId = "1105596933"


func kApi163HttpURL(key : String) -> String {
    
    return "http://c.3g.163.com/nc/video/list/\(key)/y/0-10.html"
}

func converTime(time : NSInteger) -> String {

    let date = Date.init(timeIntervalSince1970: TimeInterval(time))
    let dateFormatter = DateFormatter()
    
        if time / 3600 >= 1 {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "mm:ss"
        }
    
    let stringTime = dateFormatter.string(from: date)
    
    return stringTime
}


func transformToPinyin(key : String) -> String {
    let stringRef = NSMutableString(string: key) as CFMutableString
    // 转换为带音标的拼音
    CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
    // 去掉音标
    CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
    let pinyin = stringRef as String;
    return transformToPinyinWithoutBlank(key:pinyin)
}

func transformToPinyinWithoutBlank(key : String) -> String {
    // 去掉空格
    let pinyin = key.replacingOccurrences(of: " ", with: "")
    print(key,pinyin)
    return pinyin
}


// MARK: - 通知keyName

let LoginNsnotifaction = "loginNsnotifaction"

let Window = UIApplication.shared.windows.last



struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
}

