//
//  UserViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class UserViewController: UIViewController ,ExpanHeaderViewDelegate {
    
    var tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCreateTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isLogin), name: NSNotification.Name(rawValue: LoginNsnotifaction), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        isLogin()
        
        for view in (Window?.subviews)! {
            if view.isKind(of: UIButton.classForCoder()) {
                view.isHidden = true
            }
        }
        
    }
    
   @objc func isLogin() {
        
        UserServer.shared.loginActive { (userStateModel) in
            print(userStateModel)
            guard userStateModel.active == true else {
                self.expanHeadViews.roloadDate(state: false , model: userStateModel)
                return
            }
            self.expanHeadViews.roloadDate(state: true , model: userStateModel)
        }
    }
    
    func didTouchUpinSides(type: NSInteger) {

        guard type == 3 else {
             // 普通登录
            let viewC = LoginViewController()
            self.present(viewC, animated: true, completion: nil)
            return
        }
         // qq 登录
        LGTencentLogin.login()
        

    }
    
     func setCreateTableView () {
        
        let tableview = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.showsVerticalScrollIndicator = true
        tableview.showsHorizontalScrollIndicator = true
        tableview.register(MyTableViewCell.classForCoder(), forCellReuseIdentifier: MyTableViewCell.identfier!)
        tableview.separatorStyle = .none
        
        self.view.addSubview(tableview)
        self.tableView = tableview
        self.tableView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
         self.tableView.addSubview(self.expanHeadViews)
    }
    
    
    lazy var expanHeadViews : ExpandHeaderView = {
        
        var exV = ExpandHeaderView()
        exV.delegate = self
        exV.expandHeaderWithScorollView(scrollview:self.tableView)
        return exV
        
        
    }()
    
    
    lazy var items : NSArray = {
        var items = NSArray()
        let cachePath = "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/My.plist"
        let bundle = Bundle.main
        let myItem:String = "My"
        let plistPath = bundle.path(forResource: myItem, ofType: "plist")
        items = NSArray.init(contentsOfFile: plistPath!)!
        var arrayM = NSMutableArray()
        for array in items  {
            arrayM.add(array)
        }
        return arrayM
    }()
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource , SettingViewControllerDelegate , MyHeadViewDelegate{
    
    func clickCollectTouchUpInside() {
        print("收藏")
        let collecV = CollectViewController()
        self.navigationController?.pushViewController(collecV, animated: true)
    }
    
    func didExitLogin() {
         self.expanHeadViews.roloadDate(state: false,model: UserCenter())
         LGTencentLogin.exLogin()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.items[section] as! NSArray
        print(item.count)
        return item.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
          let view = MyHeadView()
          view.delegate = self
          return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 75
        }
        return 15
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier:MyTableViewCell.identfier!) as! MyTableViewCell
        let arrayM = self.items[indexPath.section] as! NSArray
        let dict = arrayM[indexPath.row] as! NSDictionary
        cell.dict = dict
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 2 {

                let settingView = SettingViewController()
                settingView.delegate = self
                self.navigationController?.pushViewController(settingView, animated: true)
                
            }
        }
    }
    
}
