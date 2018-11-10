//
//  VideoModel.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/31.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class VideoModel: NSObject {
    
    
    var sizeHD = String()
    
    var videoTopic = [String : AnyObject]()
    
    var mp4HD_url : String?

    var mp4_url = String()
    
    var title = String()
    
    var vid = String()
    
    var cover = String()
    
    var ptime = String()
    
    var topoclmg = String()
    
    var videosource = String()
    
    var topicDesc = String()
    
    var lengthTime = NSInteger()
    
    
    init(dict : [String : AnyObject]) {
        mp4HD_url = dict["mp4Hd_url"] as? String
        if mp4HD_url == nil {
            mp4HD_url = ""
        }
        mp4_url = dict["mp4_url"] as! String
        title = dict.valueOfString(key: "title")
        cover = dict.valueOfString(key: "cover")
        lengthTime = dict.valueOfInteger(key: "length")
        topoclmg = dict.valueOfString(key: "topicImg")
        ptime = dict.valueOfString(key: "ptime")
    }
    

}
