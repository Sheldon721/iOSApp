//
//  TitleView.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/30.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit



protocol titleNavDelegate : NSObjectProtocol {
    func didTitleNavTouchIdUpinside(key : String)
}

class TitleView: UIView {
    
    var titleButton = UIButton()
    
    var lineImage = UIImageView()
    
    var items = Array<String>()
    
    var keyItems = Array<String>()
    
    var prevButton = UIButton()
    
    var delegate : titleNavDelegate?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        items = ["奇葩" , "萌物" , "精品"]
        keyItems = ["VAP4BFE3U" , "VAP4BFR16" , "VAP4BGTVD"]
        
        setup()
    }
    
    func selectType(index : Int) {
        didTouchUpInside(sender: cacherArray[index] as! UIButton)
    }
    
    
    @objc func didTouchUpInside(sender : UIButton) {
        
     print(sender.tag,self.prevButton.tag,sender.frame.size.width,self.prevButton.frame.width)
    
        if self.prevButton.frame.size.width != 0 {
            if sender.tag == self.prevButton.tag {
                self.delegate?.didTitleNavTouchIdUpinside(key: keyItems[sender.tag])
                return
            }
        }

        
     self.prevButton.titleLabel?.font = fontSize(key: 13)
        
     self.prevButton.isSelected = sender.isSelected
     sender.isSelected = !self.prevButton.isSelected
     self.prevButton = sender
     
        if self.prevButton.isSelected {
            self.prevButton.titleLabel?.font = fontSize(key: 16)
        }
        
        
     let w = (Kwidth / 1.8) / 3 - 20
     UIView.animate(withDuration: 0.3) {
        self.lineImage.frame = CGRect.init(x: sender.center.x - (w / CGFloat(2)), y: 35, width: w, height: 0.5)
     }
    
    print(sender.tag)
    self.delegate?.didTitleNavTouchIdUpinside(key: keyItems[sender.tag])
        
    }
    
    
    lazy var cacherArray : NSMutableArray = {
       let array = NSMutableArray()
        return array
    }()
    
    lazy var lineArray : NSMutableArray = {
        let array = NSMutableArray()
        return array
    }()
    
    func setup() {
        
    
        for i in 0..<items.count {
            
            let button = makeCreateButton(tags: i , titleName:items[i])
            let x = Kwidth / 1.8 / 3
            let w = (Kwidth / 1.8) / 3
            button.frame = CGRect.init(x: x * CGFloat(i), y: 3, width: w, height: 33)
            
            cacherArray.add(button)
            
        }
        
        let line = makeCreateImage()
        let lineW = (Kwidth / 1.8) / 3 - 20
        line.frame = CGRect.init(x: 10, y: 35, width: lineW, height: 0.5)
        lineImage = line
        lineArray.add(line)
        
        
    }
    
    
    func makeCreateButton(tags : Int , titleName : String) -> UIButton {

        let button = UIButton()
        button.tag = tags
        button.setTitle(titleName, for: .normal)
        button.titleLabel?.font = fontSize(key: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor.white, for: .disabled)
        
        button.addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(button)
        return button
    }
    
    func makeCreateImage() -> UIImageView{
        
        let image = UIImageView()
        image.backgroundColor = UIColor.white
        self.addSubview(image)
        return image
    }
}
