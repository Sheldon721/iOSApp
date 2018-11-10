//
//  VideoTableViewCell.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/31.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import AVKit
class VideoTableViewCell: UITableViewCell {
    
    
    
    var playButton = UIButton()
    
    var iconimgae = UIButton()
    
    var bgImage = UIImageView()
    
    var timelabel = UILabel()
    
    var headImage = UIImageView()
    
    var titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
   @objc func didtouchupInside(sender: UIButton) {
    
    }
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addConstraints()
        self.selectionStyle = .none
    }

    
    
    
    var model : VideoModel? {
        didSet{
            self.bgImage.kf.setImage(with: URL.init(string: (model?.cover)!))
            self.headImage.kf_setImage(with: URL.init(string: (model?.topoclmg)!), placeholder: UIImage(named:"empty_video"), options: nil, progressBlock: nil, completionHandler: nil)
            self.timelabel.text = converTime(time: (model?.lengthTime)!)
            self.titleLabel.text = model?.title
        }
    }
    
    
    func setup() {
        
        self.bgImage = makeCrateimage()
        self.playButton = makeCreateButton()
        self.playButton.setImage(UIImage(named:"FullPlay_60x60_"), for: .normal)
        self.playButton.addTarget(self, action: #selector(didtouchupInside(sender:)), for: .touchUpInside)
        self.headImage = makeCrateimage()
        self.headImage.layer.cornerRadius = 12
        self.headImage.layer.masksToBounds = true
        self.timelabel = makeCreatrLabel(fontColor: UIColor.white)
        self.timelabel.textAlignment = .center
        self.timelabel.layer.cornerRadius = 10
        self.timelabel.layer.masksToBounds = true
        self.timelabel.textColor = UIColor.init(hexString: "ffffff")
        self.timelabel.backgroundColor = UIColor.init(red: 1/255, green: 1/255, blue:1/255, alpha: 0.3)
        
        self.titleLabel = makeCreatrLabel(fontColor: UIColor.black)
        
    }
    
    func addConstraints() {
        
        self.bgImage.snp_makeConstraints { (make) in
           make.top.equalTo(self.contentView)
           make.height.equalTo(Kwidth * 0.58)
           make.left.right.equalTo(self.contentView)
        }
        
        self.playButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-20)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        
        self.headImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
            make.bottom.equalTo(self.contentView).offset(-14)
        }

      
        
        self.titleLabel.snp_makeConstraints { (make) in

            make.left.equalTo(self.headImage.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.headImage)
            make.height.equalTo(22)
        }
        
        self.timelabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.bgImage.snp_bottom).offset(-5)
            make.right.equalTo(self.contentView).offset(-10)
            make.width.equalTo(45)
            make.height.equalTo(20)
        }
        
    }
    
    func makeCreateButton() -> UIButton {
        
        let button = UIButton()
        self.contentView.addSubview(button)
        
        
        return button
    }
    
    
    func makeCreatrLabel(fontColor : UIColor) -> UILabel {
        
        let label = UILabel()
        label.font = fontSize(key: 13)
        label.textColor = fontColor
        self.contentView.addSubview(label)
        
        return label
    }
    
    func makeCrateimage() -> UIImageView {
        
        let image = UIImageView()
        self.contentView.addSubview(image)
        return image
    }
    
    
    static var identfier : String? {
       return "VideoTableViewCell"
    }
}


