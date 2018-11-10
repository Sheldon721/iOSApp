//
//  ApiManager.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/28.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import Alamofire
class ApiManager: NSObject {
    
    
    /// 单例
    static let shareNetworkTool = ApiManager()
    
    
    
    func sendHttp(key : String, finished:@escaping (APIRespons) ->()){

        print(transformToPinyin(key: key))
        let url = kApiHttpURL + "type=\(transformToPinyin(key: key))&" + "key=\(appkey)"
        print("------------------+++",url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            
            let r = APIRespons()
            
            let jsonResult = response.result.value as? [String : AnyObject]
            print("234 --------- ",response.result.value)
            let reason = jsonResult?["reason"] as! String
            
            let code = jsonResult?["error_code"] as! Int
            
            r.status = code == 0 ? true : false
            r.reason = reason
            r.result = jsonResult?["result"] as? NSDictionary
            finished(r)
        }
        
        
        
    }
//
//    func loadingData() {
//         let params =  NSMutableDictionary()
//         params.setValue("21ac5e6f5a6ce57a7c68e9d", forKey: "userid")
//         let url = "http://api.example.com/getuser";
//         Alamofire.request(url, method: .post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//              let jsonresult = response.result.value  as? [String : AnyObject]
////            print(jsonresult!["username"]as! String)
//         }
//    }
//    
    
    func sendVideoHttp(key : String, finished:@escaping (APIRespons) ->()){

        print(kApi163HttpURL(key: key))
        Alamofire.request(kApi163HttpURL(key: key), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            let jsonResult = response.result.value as? [String : AnyObject]
            print(jsonResult![key])
            let r = APIRespons()
            let restltArray  = jsonResult![key] as! NSArray
            r.restltArray = restltArray
            finished(r)
            
        }
      
    }
    
    
//    func transformToPinyin(key : String) -> String {
//        let stringRef = NSMutableString(string: key) as CFMutableString
//        // 转换为带音标的拼音
//        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
//        // 去掉音标
//        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
//        let pinyin = stringRef as String;
//        return transformToPinyinWithoutBlank(key:pinyin)
//    }
//
//    func transformToPinyinWithoutBlank(key : String) -> String {
//        let s = NSString()
//        // 去掉空格
//        let pinyin = key.replacingOccurrences(of: " ", with: "")
//        print(key,pinyin)
//        return pinyin
//    }

        
        
        
    

}
