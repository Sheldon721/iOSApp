//
//  LGTextField.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/24.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
class LGTextField: UITextView {
    
//    var placeholder = String()
    
    var placeholderColor = UIColor()
    
    var maxlength = NSInteger()
    
    var placeholderLabel = UILabel()
    
    var cornerRadius = CGFloat()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    
    
    
    func setup() {
        
        var placeholderLabel = UILabel()
        placeholderLabel.font = fontSize(key: 14)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = self.placeholderColor
        self.addSubview(placeholderLabel)
        
        self.placeholderLabel = placeholderLabel
        
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(6)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.height.equalTo(22)
        }
        
        self.delegate = self
        
        self.layer.borderColor = UIColor.init(hexString: "DDDDDD").cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = cornerRadius
        
        self.tintColor = UIColor.init(hexString: "FF6200")
        self.textColor = UIColor.init(hexString: "666666")
        self.textContainerInset = UIEdgeInsets.init(top: 5, left: 2, bottom: 0, right:2)
        
    }

    
    
    var placeholder = String() {
        
        didSet{
            self.placeholderLabel.text = placeholder
            if placeholder.characters.count != 0 {
                self.placeholderLabel.isHidden = true
            }else {
                self.placeholderLabel.isHidden = false
            }
        }
    }
    
    
    
    
    
}

extension LGTextField : UITextViewDelegate {
    override public var text: String? {
        didSet{
            if text?.characters.count == 0 {
                
                self.placeholderLabel.isHidden = true
            }else{
                self.placeholderLabel.isHidden = false
            }
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = (textView.text.characters.count != 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.maxlength != 0 && textView.text.characters.count >= self.maxlength {
            if text == "" {
                return true
            }
            return false
        }
        return true
    }
    
    
    
}

