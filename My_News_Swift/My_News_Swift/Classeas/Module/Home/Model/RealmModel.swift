//
//  RealmModel.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/29.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
class HomeRealmModel : Object {
    @objc dynamic var id = String()
    @objc dynamic var result = NSData()
    override static func primaryKey() -> String? {
        return "id"
    }
}
