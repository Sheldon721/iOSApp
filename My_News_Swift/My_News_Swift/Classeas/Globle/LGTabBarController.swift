//
//  LGTabBarController.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class LGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = UITabBar.appearance()
        addChidViewControllers()
        tabBar.tintColor = UIColor.init(hexString: "ffaa00")
        
    }

    private func addChidViewControllers() {
        addChildViewControllers(childViewColler:HomeViewController(), title: "新闻", imageName: "tabbar_news",selectedImageName: "tabbar_news_hl")
//        addChildViewControllers(childViewColler:PhotoViewController(), title: "照片", imageName: "tabbar_picture",selectedImageName: "tabbar_picture_hl")
        addChildViewControllers(childViewColler: VideoViewController(), title: "视频", imageName: "tabbar_video",selectedImageName:"tabbar_video_hl")
        addChildViewControllers(childViewColler: UserViewController(), title: "我的", imageName: "tabbar_setting",selectedImageName:"tabbar_setting_hl")
        
    }
    
    private func addChildViewControllers(childViewColler:UIViewController , title:String , imageName:String , selectedImageName :String){
        
        childViewColler.tabBarItem.image = UIImage(named: imageName)
        
        childViewColler.tabBarItem.selectedImage = UIImage(named : selectedImageName)
        
        childViewColler.title = title
        
        let navc = LGNavigationController(rootViewController :childViewColler)
        
        addChildViewController(navc)
        
    }

}
