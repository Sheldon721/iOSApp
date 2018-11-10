//
//  HomeNewsMoreCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/30.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class HomeNewsMoreCell: UITableViewCell {

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
            self.oneImage.kf.setImage(with:URL.init(string: (items?.phoneOne)!))
            self.twoImage.kf.setImage(with:URL.init(string: (items?.phoneTwo)!))
//            self.thereImage.kf_setImage(with: URL.init(string: (items?.phoneThree)!))
            self.thereImage.kf.setImage(with: URL.init(string: (items?.phoneThree)!), placeholder: UIImage(named:"toutiaoquan_release_image_night_24x24_"), options: nil, progressBlock: nil, completionHandler: nil)
            self.sourceLabel.text = items?.category
            self.dateTimeLabel.text = items?.dateTime
            
        }
    }
    
    
    func setupUI() {
        
        self.titleLabel = makeCreateLabel(fontSizes: 14, fontColor: UIColor.init(hexString: "4e4e4e"))
        self.titleLabel.textAlignment = .left
        self.titleLabel.sizeToFit()
        
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
        
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
        }
        
        self.oneImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
            make.width.equalTo((Kwidth - CGFloat(40)) / CGFloat(3))
            make.height.equalTo(73)
        }
        
        self.twoImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.oneImage.snp_right).offset(10)
            make.top.width.equalTo(self.oneImage)
            make.height.equalTo(self.oneImage)
        }
        
        self.thereImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.twoImage.snp_right).offset(10)
            make.top.width.equalTo(self.oneImage)
            make.height.equalTo(self.oneImage)
        }
        
        self.sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.size.equalTo(CGSize.init(width: 25, height:18))
            make.top.equalTo(self.oneImage.snp_bottom).offset(8)
        }
        
        self.dateTimeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.sourceLabel.snp_right).offset(5)
            make.top.equalTo(self.sourceLabel)
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
        return "HomeNewsMoreCell"
    }

}
