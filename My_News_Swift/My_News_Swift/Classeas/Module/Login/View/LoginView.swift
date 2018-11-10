//
//  LoginView.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/24.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit


protocol loginViewDelegate : NSObjectProtocol {
    func gotoLoginItems(account : String , pwd : String)
    
    func gotoLoginType(type : NSInteger)
}


class LoginView: UIView {
    
    var titleLabel = UILabel()
    
    
    var oneimageView = UIImageView()
    
    var twoImageView = UIImageView()
    
    var phoneTextView = UITextField()
    
    var pwdTextView = UITextField()
    
    var gotoLogin = UIButton()
    
    var agreementlabel = UILabel()
    
    var thirdButton = UIButton()
    
    var items = NSArray()
    
    var lineimage = UIImageView()
    
    var validationButton = UIButton()
    
    var selectButton = UIButton()
    
    var regisButton = UIButton()
    
    var delegate : loginViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addContraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTouch), name: NSNotification.Name(rawValue: "didTouch"), object: nil)
    }
    
    @objc func didTouch() {
        var sender = UIButton()
        sender.isSelected = true
       gotoRegisAccount(sender:sender)
    }
    
    @objc func gotoLogin(sender : UIButton) {
        
        self.delegate?.gotoLoginItems(account: self.phoneTextView.text!, pwd: self.pwdTextView.text!)
        
    }
    
    @objc func gotoRegisAccount(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        self.titleLabel.text = sender.isSelected ? "注册一个账号,遨游新闻内容": "登录你的头条,精彩永不丢失"
        self.gotoLogin.setTitle(sender.isSelected ? "注册账号" : "进入头条", for: .normal)
        self.delegate?.gotoLoginType(type: sender.isSelected ? 1 : 0)
    }
    
    
    func setup() {
        

        
        self.titleLabel = makeCreateLabel(title: "登录你的头条,精彩永不丢失", fontColor: UIColor.black, fontSizes: 24)
        self.titleLabel.textAlignment = .center
        
        self.oneimageView = makeCreateImage()
        self.twoImageView = makeCreateImage()
        
        
        self.phoneTextView = makeCreatreTextfied(type: 0)
        
        self.pwdTextView = makeCreatreTextfied(type: 1)
        
        self.lineimage = makeLineImage()
        
        self.validationButton = makeCreateButton(imageNamed: "", titleName: "发送验证码")
        self.validationButton.setTitleColor(UIColor.black, for: .normal)
        
        self.gotoLogin = makeCreateButton(imageNamed: "", titleName: "进入头条")
        self.gotoLogin.backgroundColor = UIColor.init(hexString: "EFACAB")
        self.gotoLogin.layer.cornerRadius = 22.5
        self.gotoLogin.layer.masksToBounds = true
        self.gotoLogin.addTarget(self, action: #selector(gotoLogin(sender:)), for: .touchUpInside)
        
        self.selectButton = makeCreateButton(imageNamed: "details_choose_icon_14x14_", titleName: "")
        self.selectButton.setImage(UIImage(named:"details_choose_ok_icon_14x14_"), for: .selected)
        self.selectButton.isSelected = true
        self.agreementlabel = makeCreateLabel(title: "我已阅读并同意,'用户协议和隐私条款'", fontColor: UIColor.black, fontSizes: 12)
        
        self.regisButton = makeCreateButton(imageNamed: "", titleName: "新用户,请注册账号")
        self.regisButton.setTitle("账号密码登录", for: .selected)
        self.regisButton.setTitleColor(UIColor.init(hexString: "25578F"), for: .normal)
        self.regisButton.addTarget(self, action: #selector(gotoRegisAccount(sender:)), for: .touchUpInside)
        
    }
    
    func addContraints() {
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(40)
            make.height.equalTo(30)
        }
        
        self.oneimageView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(40)
            make.height.equalTo(45)
        }
        
        
        self.twoImageView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.oneimageView)
            make.top.equalTo(self.oneimageView.snp_bottom).offset(25)
            make.height.equalTo(self.oneimageView)
        }
        
        self.phoneTextView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.oneimageView)
            make.left.equalTo(self.oneimageView.snp_left).offset(20)
            make.right.equalTo(self.oneimageView.snp_right).offset(-100)
            make.height.equalTo(25)
        }
        
        self.lineimage.snp_makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp_right).offset(5)
            make.height.equalTo(18)
            make.width.equalTo(1)
            make.centerY.equalTo(self.oneimageView)
        }
        
        self.validationButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.lineimage.snp_right).offset(5)
            make.right.equalTo(self.oneimageView.snp_right).offset(-10)
            make.centerY.equalTo(self.oneimageView)
            make.height.equalTo(20)
        }
        self.pwdTextView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.twoImageView)
            make.left.equalTo(self.twoImageView.snp_left).offset(20)
            make.right.equalTo(self.twoImageView.snp_right).offset(-30)
            make.height.equalTo(25)
        }
        
        self.gotoLogin.snp_makeConstraints { (make) in
             make.left.right.equalTo(self.oneimageView)
             make.height.equalTo(self.oneimageView)
             make.top.equalTo(self.twoImageView.snp_bottom).offset(25)
        }
        
        self.agreementlabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(30)
            make.top.equalTo(self.gotoLogin.snp_bottom).offset(10)
            make.size.equalTo(CGSize.init(width: 220, height: 18))
        }
        
        self.selectButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.agreementlabel.snp_left).offset(-5)
            make.centerY.equalTo(self.agreementlabel)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        
        self.regisButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.agreementlabel.snp_bottom).offset(30)
            make.height.equalTo(20)
        }
        
    }
    
    
    
    func makeCreateButton(imageNamed: String , titleName: String) -> UIButton {
        
        let button = UIButton.init(type: .custom)
        button.setTitle(titleName ,for:.normal)
        button.setImage(UIImage(named:imageNamed), for: .normal)
        button.titleLabel?.font = fontSize(key: 14)
        self.addSubview(button)
        return button
    }
    
    

    func makeCreatreTextfied(type : NSInteger) -> UITextField {
        
        let textfield = UITextField()
//        textfield.backgroundColor = UIColor.red
        textfield.isSecureTextEntry = type == 1 ? true : false
        textfield.placeholder = type == 0 ? "请输入账号" : "请输入密码"
        textfield.placeholderRect(forBounds: CGRect.init(x: 20, y: 0, width: 80, height: 30))
        self.addSubview(textfield)
        return textfield
    }
    
    
    func makeCreateLabel(title: String, fontColor : UIColor, fontSizes: Int) -> UILabel {
        
        
        let label = UILabel()
        label.text = title;
        label.font = fontSize(key: fontSizes)
        label.textColor = fontColor
        self.addSubview(label)
        return label
    }
    
    func makeCreateImage() ->UIImageView {
        var image = UIImageView()
        image.layer.cornerRadius = 22.5
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.5
        self.addSubview(image)
        return image
    }
    
    func makeLineImage() -> UIImageView {
        
        let image = UIImageView()
        image.backgroundColor = UIColor.gray
        self.addSubview(image)
        return image
    }
    
}
