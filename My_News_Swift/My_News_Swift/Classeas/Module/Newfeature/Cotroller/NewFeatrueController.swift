//
//  NewFeatrueController.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/5.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit

protocol NewFeatrueControllerDelegate : NSObjectProtocol {
    func didSkipTouchuUpInside()
}

class NewFeatrueController: UIViewController {
    
    var skipbtn = UIButton()
    
    var bgimage = UIImageView()
    
    var delegate : NewFeatrueControllerDelegate?
    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("123")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = false
//        self.view.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.orange
        setup()
        addConstraints()
        
    }

    // 点击事件
    @objc func didTouchUpinside(sender : UIButton) {
        
        self.delegate?.didSkipTouchuUpInside()
    }
    
    func setup() {
        
        bgimage = makeCreateImage()
        bgimage.image = UIImage(named:"bg_icon")
        skipbtn = makeCreateButton()
        
    }
    
    func addConstraints() {
        
        bgimage.snp_makeConstraints { (make) in
            make.size.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        
        skipbtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.view).offset(20)
            make.size.equalTo(CGSize.init(width: 60, height: 28))
        }
    }
    
    func roloadLauage() {
        bgimage.image = UIImage(named:"bg_icon")
        skipbtn.isHidden = false
    }
    
    
    
    func makeCreateButton() ->UIButton {
        let btn = UIButton()
//        btn.isUserInteractionEnabled = true
        btn.isHidden = true
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = false
        btn.setTitle("跳过", for: .normal)
        btn.titleLabel?.font = fontSize(key: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.init(white: 0.7, alpha: 0.3)
        btn.addTarget(self, action: #selector(didTouchUpinside(sender:)), for:.touchUpInside)
        self.view.addSubview(btn)
        return btn
    }
    
    
    func makeCreateImage() ->UIImageView {
        
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        self.view.addSubview(image)
        return image
    }

}
