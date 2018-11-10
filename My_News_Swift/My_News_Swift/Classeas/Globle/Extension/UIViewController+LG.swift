//
//  UIViewController+LG.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit


extension UIViewController {
    

    func setCustomNavigationBar() {
        
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.init(hexString: "CF413A"))
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: "CF413A")), for: .default)
        // 修改导航栏字体颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UIApplication.shared.statusBarStyle = .default
    }

    func setCustomNavgitionBarRed() {
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: UIColor.red)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.red), for: .default)
        // 修改导航栏字体颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    func setBackNavigationBar() {
        let button = UIButton()
        
        button.setImage(UIImage(named: "shadow_lefterback_titlebar_press_22x22_"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        button.addTarget(self, action: #selector(navigationBackClick), for: .touchUpInside)
        let leftButon = UIBarButtonItem()
        leftButon.customView = button
        self.navigationItem.leftBarButtonItem = leftButon
        
    }
    
    
    func setBackNavigationcollectBar(type: Bool) {
        let button = UIButton()
        button.isSelected = type
        button.setImage(UIImage(named: "likeicon_actionbar_details_night_20x20_"), for: .normal)
        button.setImage(UIImage(named:"likeicon_actionbar_details_press_20x20_"), for: .selected)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(navigtionCollecBackClick(sender:)), for: .touchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = button
        self.navigationItem.rightBarButtonItem = rightButton
        
    }

    
    @objc func navigationBackClick() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func navigtionCollecBackClick(sender : UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
