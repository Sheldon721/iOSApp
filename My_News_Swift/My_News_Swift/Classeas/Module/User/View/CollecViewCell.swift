//
//  CollecViewCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/12/19.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class CollecViewCell: UITableViewCell {
    
    var iconImage = UIImageView()
    var titleName = UILabel()
    var dataTimeLabel = UILabel()
    var sourceLabel = UILabel()
    var collecImage = UIImageView()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addConstraints()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var homeModel : HomeCollectModel? {
        didSet {
            
            self.iconImage.kf_setImage(with:URL.init(string: (homeModel?.phone)!))
            self.titleName.text = homeModel?.title
            self.dataTimeLabel.text = homeModel?.dataTime
            self.sourceLabel.text = homeModel?.uniquekey
            
            
        }
    }
    
    
    func setup() {
        self.iconImage = makeCreateImage(imageNamed: "")
        self.iconImage.backgroundColor = UIColor.red
        self.titleName = makeCreatelabel(fontSizes: 14, fontColor: UIColor.black)
        self.sourceLabel = makeCreatelabel(fontSizes: 13, fontColor: UIColor.gray)
        self.dataTimeLabel = makeCreatelabel(fontSizes: 13, fontColor: UIColor.gray)
        self.collecImage = makeCreateImage(imageNamed: "likeicon_actionbar_details_press_20x20_")
        
    }
    
    func addConstraints() {
        self.iconImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 100, height: 73))
        }
        
        self.titleName.snp_makeConstraints { (make) in
            make.left.equalTo(self.iconImage.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-30)
            make.top.equalTo(self.iconImage.snp_top)
            make.height.equalTo(35)
        }
        self.sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleName)
            make.top.equalTo(self.titleName.snp_bottom)
            make.height.equalTo(self.titleName)
            make.width.equalTo(60)
        }
        self.dataTimeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.sourceLabel.snp_right)
            make.right.equalTo(self.titleName)
            make.top.equalTo(self.titleName.snp_bottom)
            make.height.equalTo(self.titleName)
            
        }
        
        self.collecImage.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-30)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        
    }
    
    static var identfier : String? {
        return "CollecViewCell"
    }
    
    
    func makeCreateImage(imageNamed:String) ->UIImageView {
        
        let image = UIImageView()
        image.image = UIImage.init(named: imageNamed)
        self.contentView.addSubview(image)
        return image
    }
    
    func makeCreatelabel(fontSizes: Int , fontColor: UIColor) -> UILabel {
        
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = fontColor
        label.font = fontSize(key: fontSizes)
        self.contentView.addSubview(label)
        return label
    }
    
    

}
