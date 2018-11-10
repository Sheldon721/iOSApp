//
//  LGChinnelListHeadView.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/3.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit

protocol LGChinnelListHeadViewDelagate : NSObjectProtocol {
    func editTouchUpInside(isSelected : Bool)
}

class LGChinnelListHeadView: UICollectionReusableView {
    
    
    var titleLabel = UILabel()
    
    var delegate : LGChinnelListHeadViewDelagate?
    
    var editButton = UIButton()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setup()
        addConstraints()
    }
    
    @objc func editTouchUpInside(sender : UIButton) {
        
        print(sender.isSelected,!sender.isSelected)
        sender.isSelected = !sender.isSelected

        self.delegate?.editTouchUpInside(isSelected: sender.isSelected)
    }
    
    func editIsSelected(selected : Bool) {
        
        editButton.isSelected = selected
    }
    
    
    var title : String? {
        didSet{
           print(title)
            self.titleLabel.text = title
        }
    }
    
    var indexPathRow : NSInteger? {
        didSet{
            if indexPathRow == 1{
                self.editButton.isHidden = true
            }else{
                self.editButton.isHidden = false
            }
        }
    }
    
    
    
    
    func setup() {
        
        titleLabel = makeCreateLabel()
        editButton = makeCreateButton()
        
    }
    
    func addConstraints() {
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self).offset(-100)
            make.centerY.equalTo(self)
            make.height.equalTo(20)
        }
        
        editButton.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-40)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 50, height: 25))
        }
        
    }
    

//    lazy var editButton : UIButton = {
//
//        var btn = UIButton.init(type: .custom)
//        btn.setTitle("编辑", for: .normal)
//        btn.setTitle("完成", for: .selected)
//        btn.setTitleColor(UIColor.init(hexString: "e8615e"), for: .normal)
//        btn.setTitleColor(UIColor.init(hexString: "e8615e"), for: .selected)
//        btn.titleLabel?.font = fontSize(key: 14)
//        btn.layer.cornerRadius = 12.5
//        btn.layer.masksToBounds = false
//        btn.layer.borderColor = UIColor.init(hexString: "e8615e").cgColor
//        btn.layer.borderWidth = 0.5
//        btn.addTarget(self, action: #selector(editTouchUpInside(sender:)), for: .touchUpInside)
//        self.addSubview(btn)
//        return btn
//    }()
//
    func makeCreateButton() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("编辑", for: .normal)
        btn.setTitle("完成", for: .selected)
        btn.setTitleColor(UIColor.init(hexString: "e8615e"), for: .normal)
        btn.setTitleColor(UIColor.init(hexString: "e8615e"), for: .selected)
        btn.titleLabel?.font = fontSize(key: 14)
        btn.layer.cornerRadius = 12.5
        btn.layer.masksToBounds = false
        btn.layer.borderColor = UIColor.init(hexString: "e8615e").cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(editTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }
    
    
    func makeCreateLabel() ->UILabel {
    
        let label = UILabel()
        label.font = fontSize(key: 14)
        label.textColor = UIColor.black
        label.textAlignment = .left
        self.addSubview(label)

        return label
    }
    
    
    static var identfier : String? {
        
        return "LGChinnelListHeadView"
    }
    
        
}
