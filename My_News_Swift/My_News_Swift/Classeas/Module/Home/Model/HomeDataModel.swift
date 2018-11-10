//
//  HomeDataModel.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/30.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class HomeDataModel: NSObject {
    
    var author_name = String()
    var category = String()
    var dateTime = String()
    var phoneOne = String()
    var phoneTwo = String()
    var phoneThree = String()
    var title = String()
    var uniquekey = String()
    var url = String()
    var UiStyle = Bool()
    
    init(dict : [String : AnyObject]) {
        
        print(dict)
        self.author_name = dict.valueOfString(key: "author_name")
        self.category = dict.valueOfString(key: "category")
        self.dateTime = dict.valueOfString(key: "date")
        self.phoneOne = dict.valueOfString(key: "thumbnail_pic_s")
        self.phoneTwo = dict.valueOfString(key: "thumbnail_pic_s02")
        self.phoneThree = dict.valueOfString(key: "thumbnail_pic_s03")
        self.title = dict.valueOfString(key: "title")
        self.uniquekey = dict.valueOfString(key: "uniquekey")
        self.url = dict.valueOfString(key: "url")
        print(self.phoneTwo.count)
        guard self.phoneTwo.characters.count == 0 else {
            self.UiStyle = false
            return
        }
        
        print(url)
        self.UiStyle = true
    }
}
