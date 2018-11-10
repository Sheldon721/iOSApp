//
//  UserCenter.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/26.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
class UserCenter: Object {
    
    @objc dynamic var account = String()
    
    @objc dynamic var password = String()
    
    @objc dynamic var imageURl = String()
    
    @objc dynamic var active = Bool()

    override static func primaryKey() -> String? {
        return "account"
    }
    
}
