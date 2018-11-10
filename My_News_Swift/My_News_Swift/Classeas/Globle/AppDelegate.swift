//
//  AppDelegate.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import Kingfisher
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,NewFeatrueControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LGTabBarController()
        window?.makeKeyAndVisible()
        LGTencentLogin.registeApp(appID: qqAppleId, appKey: "")
        
   
        fetchStartpage()
        
         KingfisherManager.shared.cache.maxDiskCacheSize = 10 * 1024 * 1024
        
         KingfisherManager.shared.cache.maxCachePeriodInSecond = 60 * 60 * 24
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        
         if urlKey == "com.tencent.mqq"
         {
         // QQ 的回调
            print(url)
            LGTencentLogin.shared.tencentQQ(url: url)
            
            return true
         }
        
        
        return true
    }
    

    
    func didSkipTouchuUpInside() {
        let viewss = self.window?.subviews[1]
        viewss?.isHidden = true
        
        for views in (Window?.subviews)! {
            if views.isKind(of: UIButton.classForCoder()) {
                views.isHidden = false
            }
        }
    }

 
    func fetchStartpage() {
        
        let views = NewFeatrueController()
        views.delegate = self
        Window?.addSubview(views.view)
        print(window?.subviews.count)
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:
            {
                views.roloadLauage()
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:
                    {
                        let viewss = self.window?.subviews[1]
                        viewss?.isHidden = true

                        for views in (Window?.subviews)! {
                            if views.isKind(of: UIButton.classForCoder()) {
                                views.isHidden = false
                            }
                        }

                })
        })
        
        
   

        
    }

}

