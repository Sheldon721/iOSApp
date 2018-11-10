//
//  FastPlayerView.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/16.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
class FastPlayerView: UIView {
    
    var sider = UISlider()
    
    var player = UIButton()
    
    var gotimelabel = UILabel()
    
    var totalTimelabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // 滑动时触发
    func didSlippageTime(cuttime : Double , type: Bool){
        
        
        
    }
    
    // 总时长
    var totalTime: Double? {
        didSet {
    
        }
    }
    
    func setup() {

        player = makeCteateButton(imageNamed: "play_fast_icon", selectImge: "")
        player.backgroundColor = UIColor.green
        
        print(player)
        gotimelabel = makeCreateLabel(fontColor: UIColor.red)
        gotimelabel.text = "00:28"
        gotimelabel.textAlignment = .right
//        gotimelabel.backgroundColor = UIColor.gray
        
        totalTimelabel = makeCreateLabel(fontColor: UIColor.white)
        totalTimelabel.text = "/01:15"
        totalTimelabel.textAlignment = .left
//        totalTimelabel.backgroundColor = UIColor.green
        
        sider = makeCreateSlider()
        
         addConstraints()
          print(player)
    }
    
    func addConstraints() {
        
        player.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
//            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(-10)
//            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        let mX = self.frame.maxX - self.frame.minX
        print(mX)
//
        gotimelabel.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo((Kwidth / 4))
            make.height.equalTo(20)
            make.top.equalTo(self.player.snp_bottom).offset(10)
        }

        totalTimelabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.gotimelabel.snp_right)
            make.width.equalTo((Kwidth / 4))
            make.height.equalTo(20)
            make.top.equalTo(self.gotimelabel)
        }
//
//
        sider.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.totalTimelabel.snp_bottom).offset(20)
        }
        
    }


    
    func makeCreateSlider()  ->UISlider {
        let sider  = UISlider()
//        sider.isHidden = true
        sider.minimumValue = 0
        sider.maximumValue = 1
        sider.value = 0
        sider.maximumTrackTintColor = UIColor.init(white: 1, alpha: 0.5)
        sider.minimumTrackTintColor = UIColor.red
        sider.setThumbImage(UIImage.init(color: UIColor.init(white: 1, alpha: 0)), for: .normal)
//        sider.currentThumbImage = UIImage.init(color: UIColor.init(white: 1, alpha: 0))
        self.addSubview(sider)
        
        return sider
    }
    
    func makeCteateButton(imageNamed: String , selectImge : String) ->UIButton {
        
        let button = UIButton()
        button.isUserInteractionEnabled = false
//        button.isHidden = true
        button.setImage(UIImage(named:imageNamed), for: .normal)
        button.setImage(UIImage(named:selectImge), for: .selected)
        self.addSubview(button)
        return button
    }
    
    func makeCreateLabel(fontColor: UIColor) ->UILabel {
        
        let label = UILabel()
//        label.backgroundColor = fonttColor
        label.textColor = fontColor
        label.font = fontSize(key: 13)
        self.addSubview(label)
        return label
    }
}
