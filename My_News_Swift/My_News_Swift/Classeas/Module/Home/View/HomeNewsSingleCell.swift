//
//  HomeNewsSingleCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/30.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HomeNewsSingleCell: UITableViewCell {
    
    var titleLabel = UILabel()
    
    var imageURL = UIImageView()
    
    var tagView = UIImageView()
    
    var sourceLabel = UILabel()
    
    var dateTimeLabel = UILabel()
    
    var oneImage = UIImageView()
    
    var twoImage = UIImageView()
    
    var thereImage = UIImageView()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
        addConstraints()
    }
    
    
    var items : HomeDataModel? {
        didSet{
            print(items?.title)
            self.titleLabel.text = items?.title;
            self.imageURL.kf_setImage(with:URL.init(string: (items?.phoneOne)!))
            self.sourceLabel.text = items?.category
            self.dateTimeLabel.text = items?.dateTime
        }
    }
    
    
    
    
    func setupUI() {
        
        self.titleLabel = makeCreateLabel(fontSizes: 14, fontColor: UIColor.init(hexString: "4e4e4e"))
        self.titleLabel.textAlignment = .left
        self.titleLabel.sizeToFit()
        
        self.imageURL = makeCreatrImage()
        
        self.tagView = makeCreatrImage()
        
        self.sourceLabel = makeCreateLabel(fontSizes: 11, fontColor: UIColor.init(hexString: "999999"))
        self.sourceLabel.textAlignment = .left
        
        self.dateTimeLabel = makeCreateLabel(fontSizes: 11, fontColor: UIColor.init(hexString: "999999"))
        self.dateTimeLabel.textAlignment = .left
        
        
        self.oneImage = makeCreatrImage()
        
        self.twoImage = makeCreatrImage()
        
        self.thereImage = makeCreatrImage()
        
    }
    
    
    func addConstraints() {
        
        
        self.imageURL.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-5)
            make.top.equalTo(self.contentView).offset(5)
            make.size.equalTo(CGSize.init(width: 100 ,height: 73))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.imageURL.snp_left).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
        }
    
        
        self.sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.size.equalTo(CGSize.init(width: 29, height:18))
            make.bottom.equalTo(self.imageURL.snp_bottom).offset(-10)
        }
        
        self.dateTimeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.sourceLabel.snp_right).offset(5)
            make.bottom.equalTo(self.sourceLabel)
            make.right.equalTo(self.contentView).offset(-10)
            make.height.equalTo(18)
            
        }
        
        
    
        
    }
    
    
    func makeCreateLabel(fontSizes: NSInteger , fontColor : UIColor) -> UILabel {
        
        let lable = UILabel()
        lable.font = fontSize(key:Int(fontSizes))
        lable.textColor = fontColor
        lable.numberOfLines = 0
        lable.textAlignment = .center
        self.contentView.addSubview(lable)
        return lable
    }
    
    func makeCreatrImage() -> UIImageView {
        
        let image = UIImageView()
        self.contentView.addSubview(image)
        return image
        
    }
    
    static var identfier : String? {
        return "HomeNewsSingleCell"
    }
}

