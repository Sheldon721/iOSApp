//
//  ExpandHeaderView.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/23.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit

protocol ExpanHeaderViewDelegate : NSObjectProtocol {
    func didTouchUpinSides(type : NSInteger)
}

class ExpandHeaderView: UIView {
    
    var bgImage = UIImageView()
    
    var titleLabel = UILabel()
    
    var phoneLoginBtn = UIButton()
    
    var weatchLoginBtn = UIButton()
    
    var qqLoginBtn = UIButton()
    
    var smallLoginBtn = UIButton()
    
    var iconImage = UIImageView()
    
    var tagImage = UIImageView()
    
    
    
    var portraitIcon = UIImageView()
    
    var namelabel = UILabel()
    
    var oneButton = MyDefinedButton()
    
    var twoButton = MyDefinedButton()
    
    var thereButton = MyDefinedButton()
    
    var lineImage = UIImageView()
    
    var lineTwoImage = UIImageView()
    
    
    
    var delegate : ExpanHeaderViewDelegate?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addConstraints()
    }
    
    @objc func didTouchUpInside(sider: UIButton) {
      self.delegate?.didTouchUpinSides(type: sider.tag)
    }
    
    
    func roloadDate(state : Bool ,model : UserCenter) {
        if state {
            self.titleLabel.isHidden = true
            self.phoneLoginBtn.isHidden  = true
            self.weatchLoginBtn.isHidden  = true
            self.qqLoginBtn.isHidden  = true
            self.smallLoginBtn.isHidden  = true
            self.iconImage.isHidden  = true
            
            self.portraitIcon.isHidden = false
            self.namelabel.isHidden = false
            self.oneButton.isHidden = false
            self.twoButton.isHidden = false
            self.thereButton.isHidden = false
            self.lineImage.isHidden = false
            self.lineTwoImage.isHidden = false
            
//            self.portraitIcon.kf.setImage(with: URL.init(string: model.imageURl))
            self.portraitIcon.kf.setImage(with: URL.init(string: model.imageURl), placeholder: UIImage(named:"qqkj_allshare_60x60_"), options: nil, progressBlock: nil, completionHandler: nil)
            self.namelabel.text = model.account
            
            
        }else {
            
            self.titleLabel.isHidden = false
            self.phoneLoginBtn.isHidden  = false
            self.weatchLoginBtn.isHidden  = false
            self.qqLoginBtn.isHidden  = false
            self.smallLoginBtn.isHidden  = false
            self.iconImage.isHidden  = false
            
            self.portraitIcon.isHidden = true
            self.namelabel.isHidden = true
            self.oneButton.isHidden = true
            self.twoButton.isHidden = true
            self.thereButton.isHidden = true
            self.lineImage.isHidden = true
            self.lineTwoImage.isHidden = true
            
        }
    }
    
    
    func setup () {

        self.bgImage = makeCreatrImage(imageName: "sc_video_play_fs_loading_bg")
    
        self.titleLabel = makeCreatelabe()
        self.titleLabel.text = "登录推荐更精准"
        
        self.phoneLoginBtn = makeCreateButton(imageName: "cellphoneicon_login_profile_66x66_", tag: 1)
        self.weatchLoginBtn = makeCreateButton(imageName: "weixinicon_login_profile_66x66_" ,tag: 2)
        self.qqLoginBtn = makeCreateButton(imageName: "qq_allshare_60x60_", tag: 3)
        self.smallLoginBtn = makeCreateButton(imageName: "sinaicon_login_profile_66x66_",tag: 4)

        self.iconImage = makeCreatrImage(imageName: "right_discover_14x14_")
        
        
        self.portraitIcon = makeCreatrImage(imageName: "qqkj_allshare_night_60x60_")
        self.portraitIcon.layer.cornerRadius = 30
        self.portraitIcon.layer.masksToBounds = true
        self.portraitIcon.isHidden = true
        
        self.namelabel = makeCreatelabe()
        self.namelabel.text = "18273157435";
        self.namelabel.textAlignment = .left
        self.namelabel.isHidden = true
        
        
        self.lineImage = makeCreatrImage(imageName: "")
        self.lineImage.backgroundColor = UIColor.init(white: 0.5, alpha: 0.4)
        self.lineTwoImage = makeCreatrImage(imageName: "")
        self.lineTwoImage.backgroundColor = UIColor.init(white: 0.5, alpha: 0.4)
        
        
        self.oneButton = makeCreateDefineButton(titleName: "动态")
        self.twoButton = makeCreateDefineButton(titleName: "关注")
        self.thereButton = makeCreateDefineButton(titleName: "粉丝")
    
        
    }
    
    func addConstraints() {
        
        var leftX = Kwidth - CGFloat(294)
        
        self.bgImage.snp_makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.top.equalTo(-50)
            make.bottom.equalTo(self)
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
        }
        
        self.smallLoginBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-40)
            make.size.equalTo(CGSize.init(width: 66, height: 66))
            make.centerY.equalTo(self)
        }
        
        self.qqLoginBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.smallLoginBtn.snp_left).offset(-10)
            make.centerY.size.equalTo(self.smallLoginBtn)
        }
        self.weatchLoginBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.qqLoginBtn.snp_left).offset(-10)
            make.centerY.size.equalTo(self.smallLoginBtn)
        }
        self.phoneLoginBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.weatchLoginBtn.snp_left).offset(-10)
            make.centerY.size.equalTo(self.smallLoginBtn)
        }
        
        self.iconImage.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        
        
        
        self.portraitIcon.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.centerY.equalTo(self).offset(-16)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        self.namelabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.portraitIcon.snp_right).offset(10)
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self.portraitIcon)
            make.height.equalTo(20)
        }
        
        self.oneButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.size.equalTo(CGSize.init(width: Kwidth/3, height: 44))
            make.bottom.equalTo(self).offset(-15)
        }
        
        self.twoButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.oneButton.snp_right)
            make.size.bottom.equalTo(self.oneButton)
        }
        
        self.thereButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.twoButton.snp_right)
            make.size.bottom.equalTo(self.oneButton)
        }
        
        self.lineImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.oneButton.snp_right)
            make.centerY.equalTo(self.oneButton)
            make.size.equalTo(CGSize.init(width: 0.5, height: 33))
        }
        
        self.lineTwoImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.twoButton.snp_right)
            make.centerY.equalTo(self.twoButton)
            make.size.equalTo(CGSize.init(width: 0.5, height: 33))
        }
        
    }
    
    func expandHeaderWithScorollView(scrollview: UIScrollView) {
        
        let rect = CGRect.init(x: 0, y:-kExpandHeaderViewHeight, width: Int(Kwidth), height: kExpandHeaderViewHeight)
        
        self.frame = rect
        
        scrollview.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        scrollview.contentInset = UIEdgeInsetsMake(CGFloat(kExpandHeaderViewHeight), 0, 0, 0)
        
        scrollview.contentOffset = CGPoint.init(x: 0, y: -kExpandHeaderViewHeight)
        
        scrollview.addSubview(self)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" {
            
            let contentOffset = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            
            if contentOffset.y >= CGFloat(-kExpandHeaderViewHeight) {
                return
            }
            
            let offset = CGFloat(-kExpandHeaderViewHeight) - contentOffset.y - -50
            var frame = self.bgImage.frame
            frame.origin.y = -offset
            frame.size.height = CGFloat(kExpandHeaderViewHeight) + offset
            
            self.bgImage.frame = frame
            
        }
    }
    
    
    func makeCreateButton(imageName : String , tag : NSInteger) -> UIButton {
        
        var btn = UIButton.init(type: .custom)
        btn.tag = tag
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 33
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(didTouchUpInside(sider:)), for: .touchUpInside)
        self.addSubview(btn)
        return btn
        
    }
    
    func makeCreatrImage(imageName: String) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        self.addSubview(image)
        return image
    }
    
    func makeCreatelabe() -> UILabel {
        let label = UILabel()
        label.font = fontSize(key: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }
    
    
    func makeCreateDefineButton(titleName: String) ->MyDefinedButton {
        
        let button = MyDefinedButton()
        button.isHidden = true
        button.setTitle(titleName, for: .normal)
        self.addSubview(button)
        return button
    }
    
    var identfier : String? {
        
        return "ExpandHeaderView"
    }

}
