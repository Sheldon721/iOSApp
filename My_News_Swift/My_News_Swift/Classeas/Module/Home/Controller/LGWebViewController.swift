//
//  LGWebViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/25.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import RealmSwift
import Realm
class LGWebViewController: UIViewController{

    
    var wkwebView = WKWebView()
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackNavigationBar()
        setupUI()
        SVProgressHUD.show(withStatus: "加载中 ～ ")
     
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         SVProgressHUD.dismiss()
    }
    
    
    
    @objc override func navigtionCollecBackClick(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        let dataModel = HomeCollectModel()
        dataModel.url = (model?.url)!
        dataModel.dataTime = (model?.dateTime)!
        dataModel.title = (model?.title)!
        dataModel.phone = (model?.phoneOne)!
        dataModel.uniquekey = (model?.category)!
        dataModel.isSelected = sender.isSelected
        guard self.realm.objects(HomeCollectModel.self).count > 0 else {
   
            if sender.isSelected {
                try! self.realm.write {
               
                    self.realm.add(dataModel)
                }
            }
            return;
        }
        
        print(NSHomeDirectory())
        if sender.isSelected {
//              let status = self.realm.objects(HomeCollectModel.self).filter("url = '\(model?.url)'").count
            
            try! self.realm.write {
                self.realm.add(dataModel, update: true)
            }
        }else {
         
            try! self.realm.write {
                self.realm.add(dataModel, update: true)
              }
         
        }
    }
    
    
    func setupUI() {
        
        let wkwebView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: Kwidth, height: Kheight))
        
        wkwebView.navigationDelegate = self
        wkwebView.uiDelegate = self
        wkwebView.backgroundColor = UIColor.white
        self.view.addSubview(wkwebView)
        
        self.wkwebView = wkwebView
        
        let requst = NSURLRequest(url: url! as URL)
        var req = NSMutableURLRequest.init(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20)
        // 设置代理
        
        
        
        print(requst.url)
        // WKWebView加载请求
        self.wkwebView.load(req as URLRequest)
    }
    
    var url : URL? {
        didSet{
//            let urls = NSURL(string: URL)
            
            // 根据URL创建请求
//            let requst = NSURLRequest(url: url! as URL)
//            var req = NSMutableURLRequest.init(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20)
//            // 设置代理
//
//
//
//            print(requst.url)
//            // WKWebView加载请求
//            self.wkwebView.load(req as URLRequest)

        }
    }
    
    var model : HomeDataModel? {
        didSet{
            guard self.realm.objects(HomeCollectModel.self).count > 0 else {
                setBackNavigationcollectBars(type: false)
                return;
            }
           
            let status = self.realm.objects(HomeCollectModel.self).filter("url = '\(model?.url as! String)'").count
            if status == 0 {
               setBackNavigationcollectBars(type: false)
            }else {
                let statuss = self.realm.objects(HomeCollectModel.self).filter("url = '\(model?.url as! String)'")
                let dataModel = statuss[0] as! HomeCollectModel
                 print("+++",dataModel.isSelected , dataModel.title)
                setBackNavigationcollectBars(type: dataModel.isSelected)
            }
            
            
        }
    }

}

extension LGWebViewController : WKNavigationDelegate , WKUIDelegate {
    
    // MARK: - WKNavigationDelegate
    // (1)决定网页能否被允许跳转
//    - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("111111",webView.title)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        
//        print(navigationAction.request.url,navigationAction.request.url?.query?.characters.count)
//
//        if( navigationAction.request.url?.query?.characters.count != nil){
//
//            let urlStr = navigationAction.request.url?.query
//
//
//
//            decisionHandler(.allow)
//        }
        decisionHandler(.allow)
    }
    
    //  (2)处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
        
    }
    
    // (5)处理网页加载完成
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
          print("完成")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:
            {
               SVProgressHUD.dismiss()
        })
        

        
        
    }
    
    // (6)处理网页返回内容时发生的失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
       SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "加载网页失败")
        print("失败",error)
        
    }
    
    func setBackNavigationcollectBars(type: Bool) {
        let button = UIButton()
        button.isSelected = type
        button.setImage(UIImage(named: "likeicon_actionbar_details_night_20x20_"), for: .normal)
        button.setImage(UIImage(named:"likeicon_actionbar_details_press_20x20_"), for: .selected)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(navigtionCollecBackClick(sender:)), for: .touchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = button
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
}
