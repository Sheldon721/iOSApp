//
//  LGButton.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/23.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class LGButton: UIButton {


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.init(hexString:"666666"), for: .normal)
        self.setTitleColor(UIColor.init(hexString:"ffaa00"), for: .selected)
        
        self.adjustsImageWhenHighlighted = false
        self.titleLabel?.textAlignment = .center
    }
    
    
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let x = CGFloat.init((contentRect.size.width - 24 ) / 2)
        return CGRect.init(x: x, y: 8, width: 24, height: 24)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: contentRect.origin.x, y: 35, width: contentRect.size.width, height: 20)
    }
    
    

}
