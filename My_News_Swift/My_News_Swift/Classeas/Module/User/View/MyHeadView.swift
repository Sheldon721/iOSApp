//
//  MyHeadView.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/23.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit

protocol MyHeadViewDelegate : NSObjectProtocol {
    func clickCollectTouchUpInside()
}

class MyHeadView: UIView {

    var collectbtn = LGButton()
    
    var historybtn = LGButton()
    
    var nightbtn = LGButton()
    
    var delegate : MyHeadViewDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        setup()
        addConstraints()
    }
    
   @objc func didTouchUpInside(sender : UIButton) {
        self.delegate?.clickCollectTouchUpInside()
        
    }
    
    
    func setup() {
        
        self.collectbtn = makeCreateButton(title: "收藏", imageNamed: "favoriteicon_profile_24x24_")
        self.collectbtn.addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
        self.historybtn = makeCreateButton(title: "历史", imageNamed: "history_profile_24x24_")
        self.nightbtn = makeCreateButton(title: "夜间", imageNamed: "nighticon_profile_24x24_")
    }
    
    func addConstraints() {
        self.collectbtn.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(-15)
            make.width.equalTo(CGFloat(Kwidth / 3))
        }
        self.historybtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.collectbtn.snp_right)
            make.top.bottom.equalTo(self.collectbtn)
            make.width.equalTo(self.collectbtn)
        }
        
        self.nightbtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.historybtn.snp_right)
            make.top.bottom.equalTo(self.collectbtn)
            make.width.equalTo(self.historybtn)
        }
        
    }
    
    func makeCreateButton(title: String , imageNamed: String) -> LGButton{
        
        let btn = LGButton()
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(named:imageNamed), for: .normal)
        btn.titleLabel?.font = fontSize(key: 13)
        btn.backgroundColor = UIColor.white

        self.addSubview(btn)
        return btn
    }
    

    
    static var identfier : String? {
        return "MyHeadView"
    }

}
