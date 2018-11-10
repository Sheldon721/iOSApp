//
//  ChinnalListCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/3.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

protocol LGChinnelListViewCellDelegate : NSObjectProtocol{
    func deleteChinnel(row : Int)
}

class ChinnalListCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    
    var editButton = UIButton()
    
    var addButton = UIButton()
    
    var row = Int()
    
    var delegate : LGChinnelListViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    @objc func editTouchUpInSide(sender : UIButton) {
        
        self.delegate?.deleteChinnel(row:row)
        print("删除")
    }
    
    var indexRow : Int? {
        didSet{
            self.row = indexRow!
        }
    }
    
    
    
    func reloadSetUI(isSelect : Bool , section : Int) {
        
        if isSelect {
            if section == 0 {
                self.editButton.isHidden = false
                
            }else {
                self.editButton.isHidden = true
            }
        }else{
            self.editButton.isHidden = true
        }
        
        
        
    }
    
    func setup() {
        
        print(self.contentView.frame.maxX)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.contentView.frame.maxX, height: self.contentView.frame.maxY)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        self.contentView.addSubview(titleLabel)
        
        
        self.editButton = makeCreateButton(imageNamed: "ChinnelList_close")
        
        self.editButton.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(4)
            make.top.equalTo(self).offset(-3)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
    }
    
    
    
    var titleOne : String? {
        didSet{
            
            titleLabel.text = titleOne
            print(titleOne)
        }
    }
    
    var titleTwo : String? {
        didSet{
            titleLabel.text = titleTwo
            print(titleTwo)
        }
    }
    
    
    func makeCreateButton(imageNamed : String) ->UIButton {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named:imageNamed), for: .normal)
        btn.addTarget(self, action: #selector(editTouchUpInSide(sender:)), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }
    
    
    static var identfier : NSString? {
        
        return "ChinnalListCell"
    }
    
}
