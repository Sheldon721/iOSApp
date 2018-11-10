//
//  MyDefinedButton.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/29.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
class MyDefinedButton: UIButton {
    
    var tagLabel = UILabel()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = fontSize(key: 13)
        self.setTitleColor(UIColor.gray, for: .normal)
        
        setup()
    }
  
    func setup() {
        
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.font = fontSize(key: 14)
        label.textAlignment = .center
        self.addSubview(label)
        self.tagLabel = label
        
        print(self.frame.size.height / 2)
        self.tagLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(22)
            make.top.equalTo(self)
        }

    }
    
    var tagTitle : String? {
        didSet{
              self.tagLabel.text = tagTitle
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        var y = contentRect.size.height / 2
        print(contentRect.size.height / 2)
        return CGRect.init(x: 0, y: 22, width: contentRect.size.width, height: contentRect.size.height / 2)
    }

}
