//
//  LGTencentLogin.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/23.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
class LGTencentLogin: NSObject {
    
    static var shared : LGTencentLogin = LGTencentLogin()
    
    var tencentAuth: TencentOAuth!
    
    let realm = try! Realm()
    
    
    fileprivate var appID: String = ""
    fileprivate var appKey: String = ""
    fileprivate var accessToken: String = ""
    
    class func registeApp(appID: String, appKey: String) {
        
        LGTencentLogin.shared.tencentAuth = TencentOAuth(appId: "1105596933", andDelegate: LGTencentLogin.shared)
     
    }
    
    class func login() {
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        LGTencentLogin.shared.tencentAuth.authorize(permissions)
    }

    class func exLogin() {
       LGTencentLogin.shared.tencentAuth.logout(LGTencentLogin.shared)
    }
}

extension  LGTencentLogin : TencentSessionDelegate {
    
    func tencentQQ(url : URL) {
          TencentOAuth.handleOpen(url)
    }
    
    func tencentDidLogin() {
        print(" ----- 登录 成功 ")
        print("openId：\(tencentAuth.openId)",
            "accessToken：\(tencentAuth.accessToken)",
            "expirationDate：\(tencentAuth.expirationDate)")
        self.tencentAuth.getUserInfo()
        if let accessToken = self.tencentAuth.accessToken {
            // 获取accessToken
            self.accessToken = accessToken
        }
    }
    
    func tencentDidNotNetWork() {
         print("没有网络")
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
        if cancelled {
            // 用户取消登录
            print("用户取消登录 ")
        } else {
            // 登录失败
            print("失败")
        }
    }
    
    
    func getUserInfoResponse(_ response: APIResponse!) {

        let res = response.jsonResponse
        print(res!["nickname"] as Any,res!["gender"]!,res!["figureurl_qq_2"] as Any,self.tencentAuth.getUserOpenID())
        
        let account = res!["nickname"] as! String
        let userModel = UserCenter()
        let status =  self.realm.objects(UserCenter.self).filter("account = '\(account)'").count
       
        guard status == 1 else {
            userModel.account = account as! String
            userModel.imageURl = res!["figureurl_qq_2"] as! String
            userModel.password = "123456"
            userModel.active = true
            
            try! self.realm.write {
                self.realm.add(userModel)
            }
            SetNotificationCenter()
            return
        }
        
        userModel.account = account as! String
        userModel.imageURl = res!["figureurl_qq_2"] as! String
        userModel.password = "123456"
        userModel.active = true
        
        try! self.realm.write {
            self.realm.add(userModel, update: true)
        }
        SetNotificationCenter()
    }
    
    func SetNotificationCenter() {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LoginNsnotifaction) , object: nil)
    }
}
