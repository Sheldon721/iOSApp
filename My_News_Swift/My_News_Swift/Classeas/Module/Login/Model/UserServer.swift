//
//  UserServer.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/26.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
class UserServer: NSObject {
    
    static var shared : UserServer = UserServer()
    
    let realm = try! Realm()
    
    func isLogin(account : String , pwd : String , finished:@escaping(APIRespons) ->()) {
        
        var r = APIRespons()
        
        
        guard self.realm.objects(UserCenter.self).count > 0 else {
            print(self.realm.objects(UserCenter.self).count)
            r.status = false
            finished(r)
            return
        }
        
        let status =  self.realm.objects(UserCenter.self).filter("account = '\(account)'").count
        if status == 1 {
             let resultsModel = self.realm.objects(UserCenter.self).filter("account = '\(account)'")
             let userModel = resultsModel.first
             var user = UserCenter()
            if pwd == userModel?.password {
                r.meessage = "登录成功"
                r.status = true
                
                user.account = (userModel?.account)!
                user.imageURl = (userModel?.imageURl)!
                user.password = (userModel?.password)!
                user.active = true
                
                
                try! self.realm.write {
                    self.realm.add(user, update: true)
                }
                
                

                finished(r)
             } else {
                r.meessage = "密码错误"
                r.status = false
                finished(r)
            }
        }else {
            r.meessage = "没有此账号"
            r.status = false
            finished(r)
        }
        
      print(self.realm.objects(UserCenter.self).count,status)
        
        
        
        
        finished(r)
    }
    
    func isRegisLogin(account : String , pwd : String , finished:@escaping(Bool) ->()) {
        
        let userModel = UserCenter()
        let status =  self.realm.objects(UserCenter.self).filter("account = '\(account)'").count
        if status == 0 {
            userModel.account = account
            userModel.password = pwd
            userModel.imageURl = "qqkj_allshare_night_60x60_"
            userModel.active = true
            
            
            try! self.realm.write {
                self.realm.add(userModel)
            }
            
            finished(true)
            
        }else {
            finished(false)
        }

    }
    
    
    func exitLogin() ->Bool {

        let userModel = UserCenter()
        let status =  self.realm.objects(UserCenter.self).filter("active = true").count
        guard status == 1 else {
            
            return false
        }

        let model = self.realm.objects(UserCenter.self).filter("active = true")
        let userModels = model.first
        print(userModels)
        
        
        
        userModel.account = (userModels?.account)!
        userModel.imageURl = (userModels?.imageURl)!
        userModel.password = (userModels?.password)!
        userModel.active = false
        
        try! self.realm.write {
            self.realm.add(userModel, update: true)
        }
        return true
        
    }
    
    
    func loginActive(finished:@escaping(UserCenter) ->()) {
        let status =  self.realm.objects(UserCenter.self).filter("active = true").count
        guard status == 1 else {
            print("未登录",status)
            let models = UserCenter()
            models.active = false
            finished(models)
            return
        }
 
        var  model = self.realm.objects(UserCenter.self).filter("active = true")
        print(model)
        var models = model[0] as! UserCenter
        print(models)
        finished(models)
        
    }

    

}
