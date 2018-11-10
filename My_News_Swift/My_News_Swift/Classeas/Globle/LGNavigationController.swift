//
//  LGNavigationController.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class LGNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar.appearance()
        //        navBar.barTintColor = UIColor.init(hexString: "f5f5f5")
        //        navBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: "f5f5f5")), for: .default)
        //        navBar.setBackgroundImage(UIImage(), for: .default)
        //        navBar.shadowImage = UIImage()
        //        navBar.tintColor = UIColor.white
        //        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
        
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
                for view in (Window?.subviews)! {
                    print(view)
                    if view.isKind(of: UIButton.classForCoder()) {
                        view.isHidden = true
                    }
                }
        }
        viewController.navigationItem.hidesBackButton = true
        
        
        super.pushViewController(viewController, animated: true)
    }
    
    /// 返回按钮
    override func navigationBackClick() {
//        if SVProgressHUD.isVisible() {
//            SVProgressHUD.dismiss()
//        }
        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        popViewController(animated: true)
    }
    
//    
//    override func did() {
//         viewController.hidesBottomBarWhenPushed = true
//         viewController.navigationItem.hidesBackButton = true
//    }
}
