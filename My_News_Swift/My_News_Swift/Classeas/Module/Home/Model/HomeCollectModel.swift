//
//  HomeCollectModel.swift
//  My_News_Swift
//
//  Created by LG on 2017/12/19.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
class HomeCollectModel: Object {
    @objc dynamic var url = String()
    @objc dynamic var title = String()
    @objc dynamic var uniquekey = String()
    @objc dynamic var dataTime = String()
    @objc dynamic var phone = String()
    @objc dynamic var isSelected = Bool()
    override static func primaryKey() -> String? {
        return "url"
    }
}
