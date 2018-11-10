//
//  UserStateModel.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/29.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
class UserStateModel: Object {

    @objc dynamic var account = String()
    @objc dynamic var active = Int()
    @objc dynamic var name = String()
    @objc dynamic var imageUrl = String()
    
    override static func primaryKey() -> String? {
         return "active"
    }

}
