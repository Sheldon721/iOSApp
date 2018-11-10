//
//  LoginViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/24.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class LoginViewController: UIViewController {
    
    var thirdButton = UIButton()
    
    var items = NSArray()
    
    var bootonView = UIView()
    
    var contentView = LoginView()
    
    var closeButton = UIButton()
    
    var type = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     print(NSHomeDirectory())
        self.view.backgroundColor = UIColor.white
        items = ["qq_sdk_login_40x40_","weixin_sdk_login_40x40_","tianyi_sdk_login_40x40_","mailbox_sdk_login_40x40_"]
    
        setupUI()
        setupBootonView()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }

    
    func setupUI () {
        
        let contentView = LoginView()
        contentView.delegate = self
        self.view.addSubview(contentView)
        self.contentView = contentView
        
        
        let closeButotn = UIButton()
        //push_close_popups_28x28_
        closeButotn.setImage(UIImage(named:"close_night_24x24_"), for: .normal)
        self.closeButton = closeButotn
        closeButotn.addTarget(self, action: #selector(didCloseButton(sender:)), for: .touchUpInside)
        self.view.addSubview(closeButotn)
        
    }

    @objc func didCloseButton(sender : UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupBootonView(){
        
        let bootonView = UIView()
        self.view.addSubview(bootonView)
        self.bootonView = bootonView
        
        for i in 0..<4 {
            self.thirdButton = makeCreateButton(imageNamed: items[i] as! String, titleName:"")
            self.thirdButton.tag = i
            
            let x = Int(i * 40 + ((i + 1) * 20))
            print(i)
            self.thirdButton.frame = CGRect.init(x: CGFloat(x), y: 0, width: 40, height: 40)
        }
    }
    
    
    func addConstraints() {
        
        self.contentView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(54)
            make.bottom.equalTo(self.view).offset(-80)
        }
        
        self.bootonView.snp_makeConstraints { (make) in
            make.left.equalTo(CGFloat(Kwidth - CGFloat(260))/2)
            make.bottom.equalTo(self.view).offset(-30)
            make.height.equalTo(40)
            make.width.equalTo(260)
        }
        
        self.closeButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(25)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
    }
    
    
    
    func makeCreateButton(imageNamed: String , titleName: String) -> UIButton {
        
        let button = UIButton.init(type: .custom)
        button.setTitle(titleName ,for:.normal)
        button.setImage(UIImage(named:imageNamed), for: .normal)
        button.titleLabel?.font = fontSize(key: 14)
        self.bootonView.addSubview(button)
        return button
    }

    
    lazy var cacheArray : NSMutableArray = {
        
        var cacheArray = NSMutableArray()
        return cacheArray
        
    }()
}

extension LoginViewController : loginViewDelegate {
    
    
    func gotoLoginItems(account: String, pwd: String) {
        print(type,NSHomeDirectory())
        
        
        if account.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "账号不能为空 ～～ ")
            return
        } else if pwd.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "密码输入有误 或者格式错误 ～～ ")
            return
        } else if pwd.characters.count < 5 {
            SVProgressHUD.showError(withStatus: "密码不能少于6位数  ～～ ")
        }
        
        
        
        
        guard type == 0 else {
            UserServer.shared.isRegisLogin(account: account, pwd: pwd, finished: { (status) in
                if status {
                     SVProgressHUD.showSuccess(withStatus: "注册成功 ～")

                      NotificationCenter.default.post(name:NSNotification.Name(rawValue: "didTouch") , object: nil)
                    
                    
                } else {
                     SVProgressHUD.showError(withStatus: "账号已存在 ～～ ")
                }
            })
            // 注册
            return
        }
        
        // 密码登录
        UserServer.shared.isLogin(account: account, pwd: pwd) { (response) in

            guard response.status == true else {
                SVProgressHUD.showError(withStatus: response.meessage)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: response.meessage)
           self.didCloseButton(sender: UIButton())

        }
        
    }
    
    func gotoLoginType(type: NSInteger) {
        self.type = type
    }
}
