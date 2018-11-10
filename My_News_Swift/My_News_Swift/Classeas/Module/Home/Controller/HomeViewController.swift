 //
//  HomeViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import RealmSwift
import ESPullToRefresh
import SVProgressHUD
import Kingfisher
class HomeViewController: UIViewController {

    
    var scrollView = UIScrollView()
    
    var middleScrollView = UIScrollView()
    
    var tableView = UITableView()
    
    var selectButton = UIButton()
    
    var prevButton = UIButton()
    
    var itemsData = Array<AnyObject>()
    
    var viewController = MyNewsreceptacleViewController()
    
    let realm = try! Realm()
    
    var prevKey = String()
    
    var myView = MyView()
    
    var edButton = UIButton()

    var recordTitleArray = NSMutableArray()
    
    //MARK: 生命周期
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                print(NSHomeDirectory())
        let key = self.items().firstObject as! String
        setupData(data: NSData(), key:transformToPinyin(key: key))

        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       
        print(NSHomeDirectory())
        setupNav()
        makeCreateScrollecView()
        makeCreateTalView()
        makeCreateTopView()
        createEditButton()
        self.myView = self.viewArray[0] as! MyView
        self.myView.beginRefreshing()
        self.myChinnelListView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
        let viewH = Window?.subviews[1]
        if (viewH?.isHidden)! == false {
            for view in (Window?.subviews)! {
                print(view)
                if view.isKind(of: UIButton.classForCoder()) {
                    view.isHidden = true
                }
            }
        }else{
            for view in (Window?.subviews)! {
                print(view)
                if view.isKind(of: UIButton.classForCoder()) {
                    view.isHidden = false
                }
            }
            
        }
    }
    
    
    func setupNav (){
        setCustomNavigationBar()
    }
    
    //MARK: 懒加载
    
    lazy var cacheArray : NSMutableArray = {

        var cacheArray = NSMutableArray()
        return cacheArray
       
    }()
    
    lazy var viewArray : NSMutableArray = {
        var viewArray = NSMutableArray()
        return viewArray
    }()

    
    func items()-> NSArray {
        
        var items = NSArray()
        let cachePath = "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/HomeTitle.plist"
        items = NSArray.init(contentsOfFile: cachePath)!
        var arrayM = NSMutableArray()
        for array in items  {
            arrayM.add(array)
        }
        return arrayM
        
    }
    
    lazy var myChinnelListView : LGChinnelListView = {
       
        var chinnelListView = LGChinnelListView()
        chinnelListView.backgroundColor = UIColor.white
        chinnelListView.alpha = 0
        chinnelListView.frame = CGRect.init(x: 0, y: 64, width: Kwidth, height: 0)

        Window?.addSubview(chinnelListView)
        Window?.insertSubview(self.edButton, aboveSubview: chinnelListView)
        return chinnelListView
    }()
}

// MARK: MyViewDelegate
extension HomeViewController : MyViewDelegate {
    
    func updateRefresh(tag: NSInteger) {
        print(tag)
        let key = self.items()[tag] as! String
        self.myView = self.viewArray[tag] as! MyView
        fetchListData(key: key)
    }
    
    func didTouchUpInside(url: String, homeModol: HomeDataModel) {
        
        let webView = LGWebViewController()
        webView.url = URL.init(string: url)
        webView.model = homeModol
        self.navigationController?.pushViewController(webView, animated: true)
    }

    
}



// MARK: 获取数据
extension HomeViewController {
    
    func fetchListData(key : String) {
        
        ApiManager.shareNetworkTool.sendHttp(key: key) { (response) in
            let items = HomeRealmModel()
            // 有数据就更新
            guard self.realm.objects(HomeRealmModel.self).count > 0 else {
                // 第一次更新
                items.id = key
                let data : NSData = (NSKeyedArchiver.archivedData(withRootObject: response.result) as NSData)
                items.result = data
                try! self.realm.write {
                    self.realm.add(items)
                }
                self.setupData(data:data,key: key)
                return
            }

            items.id = key
            var data = NSData()
            if response.result == nil {

            }else{
                 data = (NSKeyedArchiver.archivedData(withRootObject: response.result) as NSData)
                items.result = data
                try! self.realm.write {
                    self.realm.add(items, update: true)
                }
            }
            self.myView.endRefreshing()
            self.setupData(data: data,key: key)

        }

        
    }
    
    
    func setupData(data : NSData , key : String) {
        
     let status = self.realm.objects(HomeRealmModel.self).filter("id = '\(key)'").count
        if status == 0 {
//            SVProgressHUD.showError(withStatus: "请求数据次数过多 ～ ")
            return
        }
     let statuss = self.realm.objects(HomeRealmModel.self).filter("id = '\(key)'")
     let dataModel = statuss[0] as! HomeRealmModel

     let dictData : NSDictionary = NSKeyedUnarchiver.unarchiveObject(with:(dataModel.result as? Data)!)as! NSDictionary
        let array = dictData.value(forKey: "data") as! NSArray
        var arrayM = NSMutableArray()
        for dict in array {
            let dataArray = [HomeDataModel.init(dict: dict as! [String : AnyObject])]
            arrayM.addObjects(from: dataArray)
        }

        self.itemsData = arrayM as [AnyObject]
        self.myView.roloadData(items: self.itemsData)
        print(self.myView.tag)

       
    }
    
}
// MARK: UIScrollViewDelegate
extension HomeViewController : UIScrollViewDelegate {
    
    // 预加载下个界面
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let i = Int(((scrollView.contentOffset.x + Kwidth / 2) / Kwidth) + 1)
        if i == viewArray.count {
            return
        }
         print(i,viewArray.count)
        self.myView = viewArray[i] as! MyView
        
        if self.myView.items.count == 0 {
            let key = self.items()[i] as! String
            setupData(data: NSData(), key: transformToPinyin(key: key))
        }
    }
    
    
    
    //  跳转视图
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int((scrollView.contentOffset.x + Kwidth / 2) / Kwidth)
        let sender = self.cacheArray[index] as! UIButton
        setupTopSelected(sender: sender as! UIButton)
        offsetX(sender: sender)
        self.myView = self.viewArray[index] as! MyView
     
        let key = self.items()[index] as! String
        
        
        print(myView.tag)
        
        fetchLoaddata(key:transformToPinyin(key: key))
        
        print(index,sender.tag);
    }
    
    func fetchLoaddata(key: String) {
        if key != prevKey {
            self.myView.beginRefreshing()
            fetchListData(key: key)
            self.prevKey = key
            return
        }
        self.prevKey = key
        
    }
}


//MARK: 创建内容视图

extension HomeViewController {
    
    func makeCreateTalView() {
        
        var scrollecView = UIScrollView()
        scrollecView.frame = CGRect.init(x: 0, y: 44, width: Kwidth, height: Kheight - (64 + 44 + 44));
        scrollecView.delegate = self;
        scrollecView.backgroundColor = UIColor.white
        scrollecView.showsVerticalScrollIndicator = true
        scrollecView.showsHorizontalScrollIndicator = true
        scrollecView.isPagingEnabled = true
        scrollecView.scrollsToTop = true
        self.view.addSubview(scrollecView)
        scrollecView.contentSize = CGSize.init(width: CGFloat((self.items().count)) * CGFloat(Kwidth), height: 0);
        
        self.middleScrollView = scrollecView;
        for i in 0..<self.items().count {
            let viewc = MyView()
            viewc.delegate = self as MyViewDelegate
            viewc.frame = CGRect.init(x: CGFloat(CGFloat(i) * Kwidth), y: 0, width: Kwidth, height:Kheight - 88)
            viewc.tag = i
            if i == 0{
                if self.itemsData.count != 0 {
                    viewc.roloadData(items: self.itemsData)
                }
                
            }else if  i == 1 {
                if self.itemsData.count != 0 {
                    viewc.roloadData(items: self.itemsData)
                }
                
            }
            self.viewArray.add(viewc)
            scrollecView.addSubview(viewc)
            
        }
        
       
    }
}


//MARK: 创建头部视图
extension HomeViewController {

    
    @objc func editButton(sender : UIButton) {

        sender.isSelected = !sender.isSelected
        guard sender.isSelected == true else {
            UIView.animate(withDuration: 0.3) {
                sender.transform = .identity
            }
            isHiddenMyChinnelListView(hidden: sender.isSelected)
            return
        }
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi / 4))
        }
        isHiddenMyChinnelListView(hidden: sender.isSelected)

    }
    func isHiddenMyChinnelListView(hidden : Bool) {
        
   
        guard hidden else {
            
//            print(self.items().count,self.cacheArray.count)
//            if self.items().count != self.cacheArray.count {
//
                self.makeCreateTopView()
//            }else{
//                let set1 = NSMutableSet.set
//            }
            UIView.animate(withDuration: 0.5, animations: {
                
                self.myChinnelListView.alpha = 0
                self.myChinnelListView.frame = CGRect.init(x: 0, y: 64, width: Kwidth, height: 0)
            })
            
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.myChinnelListView.alpha = 1
            self.myChinnelListView.frame = CGRect.init(x: 0, y: 64, width: Kwidth, height: Kheight - 64)
            self.myChinnelListView.reloadData(myChannel: self.items() as! [String], moreChannel:  self.items() as! [String])
            
           
        }
        
        
    }
    
    
    
    
    @objc func setupTopSelected(sender : UIButton) {
        print(sender.tag,self.cacheArray.count)
        
        offsetX(sender:  sender)
        UIView.animate(withDuration: 0.3) {
            self.prevButton.isSelected = false
            self.prevButton.titleLabel?.font = fontSize(key: 12)
            sender.isSelected = true
            sender.titleLabel?.font = fontSize(key: 15)
            self.prevButton = sender
        }
        
        self.myView = self.viewArray[sender.tag - 1000] as! MyView
      
        self.myView.beginRefreshing()
        
        print(self.myView)
        self.middleScrollView.contentOffset = CGPoint.init(x: CGFloat(sender.tag - 1000) * Kwidth, y: 0)
        
    }
    

    func offsetX(sender : UIButton) {

        if sender.tag - 1000 == items().count - 1 {
            return
        }
    
        var offsetPoint : CGPoint = self.scrollView.contentOffset
        offsetPoint.x =  sender.center.x -  Kwidth / 2

       
        if items().count <= 6 {
            return
        }
        //左边超出处理
        if offsetPoint.x < 0{
            offsetPoint.x = 0
        }
        let maxX : CGFloat = scrollView.contentSize.width - Kwidth;
        //右边超出处理
        if offsetPoint.x > maxX {
            offsetPoint.x = maxX
        }
         self.scrollView.setContentOffset(offsetPoint, animated: true)
        
        
    }
    
    
    
    
    func makeCreateScrollecView() {
        
        let scrollecView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: Kwidth - 35, height: 44))
        scrollecView.backgroundColor = UIColor.white
//        scrollecView.delegate = self
//        scrollecView.isScrollEnabled = false
        scrollecView.showsVerticalScrollIndicator = true
        scrollecView.showsVerticalScrollIndicator = true
        scrollecView.isPagingEnabled = false
        scrollecView.bounces = false
        scrollecView.scrollsToTop = true
          scrollView.isDirectionalLockEnabled = false
        self.view.addSubview(scrollecView)
        self.scrollView = scrollecView
    }
    
    func makeCreateTopView(){
        
        var width = CGFloat()
        
        for view in self.cacheArray {
            let views = view as! UIButton
            views.isHidden = true
        }
        
        
        for i in 0..<items().count {
            recordTitleArray.add(items()[i] as! String)
            if self.cacheArray.count > i {
                if self.cacheArray.count != 0 {
                    var btn = UIButton()
                    btn = self.cacheArray[i] as! UIButton
                    btn.isHidden = false
                    print(items()[i])
                    btn.setTitle(items()[i] as! String, for: .normal)
                    let title = items()[i] as! String
                    let rectSize = title.sizeToFots(labelStr: title, font:fontSize(key: 12)! , width: Kwidth, height: 20)
                    let x = i == 0 ? 10 : CGFloat(width) + CGFloat(rectSize.width + 30)
                    width = x
                }
               
            }else{
            
               let btn = makeCreateButton(title: items()[i] as! String)
               btn.tag = i + 1000
               btn.isHidden = false
               let title = items()[i] as! String
               let rectSize = title.sizeToFots(labelStr: title, font:fontSize(key: 12)! , width: Kwidth, height: 20)

               let x = i == 0 ? 10 : CGFloat(width) + CGFloat(rectSize.width + 30)
               width = x
                btn.frame = CGRect.init(x: x , y: 12, width:rectSize.width + 30 , height: 20)
                if i == 0 {
                    setupTopSelected(sender: btn)
                    let key = self.items()[i] as! String
                    self.prevKey = key;
                }
               self.selectButton = btn
               self.cacheArray.add(self.selectButton)
            }
            
        }
        
 
        self.scrollView.contentSize = CGSize.init(width: width + 50, height: 0)
        print(CGFloat(items().count) * CGFloat(50))
        
    }
    
    
    func makeCreateButton(title : String) -> UIButton {
        
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = fontSize(key: 12)
        
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.red, for: .selected)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action:#selector(setupTopSelected(sender:)), for: .touchUpInside)
        self.scrollView.addSubview(btn)
        return btn
    }
    func createEditButton() {
        let editBtn = UIButton.init(type: .custom)
        editBtn.setImage(UIImage(named:"add_channel"), for: .normal)
        // 22 - 12
        editBtn.frame = CGRect.init(x: Kwidth - 35, y:74, width: 24, height: 24)
        editBtn.addTarget(self, action: #selector(editButton(sender:)), for: .touchUpInside)
        
        self.view.addSubview(editBtn)
        self.edButton = editBtn
        
    }
    
}
