//
//  MyTableViewCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/23.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    
    var titleLabel = UILabel()
    
    var descLabel = UILabel()
    
    var iconImage = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
        addConstraints()
    }
    
    var dict : NSDictionary? {
        didSet{
            self.titleLabel.text = dict?.value(forKey: "title") as! String
            self.descLabel.text = dict?.value(forKey: "desc") as! String
            
        }
    }
    
    func setup() {
        
        self.titleLabel = makeCreateLabel(fontColor: UIColor.black, aligMent: .left)
        self.descLabel = makeCreateLabel(fontColor: UIColor.gray, aligMent: .right)
        self.iconImage = makeCreateImage()
        
    }
    
    func addConstraints() {
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 120, height: 20))
        }
        
        self.descLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-35)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(20)
        }
        
        self.iconImage.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-13)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
            make.centerY.equalTo(self.contentView)
        }
    }
    
 
    func makeCreateLabel(fontColor: UIColor , aligMent : NSTextAlignment) -> UILabel {
        
        let label = UILabel()
        label.font = fontSize(key: 14)
        label.textAlignment =  aligMent
        label.textColor = fontColor
        self.contentView.addSubview(label)
        return label
    }

    func makeCreateImage() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "right_discover_14x14_")
        self.contentView.addSubview(image)
        return image
    }
    
    static var identfier : String? {
         return "MyTableViewCell"
    }
    
    
}
