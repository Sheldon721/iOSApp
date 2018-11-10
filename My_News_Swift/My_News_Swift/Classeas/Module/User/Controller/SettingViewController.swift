//
//  SettingViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/2.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Kingfisher

protocol SettingViewControllerDelegate: NSObjectProtocol {
    func didExitLogin()
}

class SettingViewController: UIViewController {
    
    var items = Array<String>()
    
    var tableView = UITableView()
    
    var delegate : SettingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["编辑资料","账户和隐私设置","黑名单" ,"清除缓存","客户端版本","退出登录"]
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setCustomNavigationBar()
        setBackNavigationBar()
    }
    
    

    
    

}

extension SettingViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }else if section == 3 {
            return 20
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = self.items[indexPath.section]
        cell.textLabel?.font = fontSize(key: 14)
        cell.selectionStyle = .none
        if indexPath.section == 3 {
          
            let label = UILabel()
            label.frame = CGRect.init(x:Kwidth - 90 , y: 12, width: 80, height: 20)
            label.textColor = UIColor.gray
            label.textAlignment = .right
            label.font = fontSize(key: 13)
            cell.addSubview(label)
            KingfisherManager.shared.cache.calculateDiskCacheSize { (size) in
                label.text =  String.init(format:  "%.2f M", Double(size) / 1048576.0)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5{
                let status = UserServer.shared.exitLogin()
                if status {
                    self.delegate?.didExitLogin()
                    SVProgressHUD.showSuccess(withStatus: "退出成功 ～ ")
                    self.navigationController?.popViewController(animated: false)
                    
                }else {
                    SVProgressHUD.showError(withStatus: "未登录 ～ ")
                }
        }else if indexPath.section == 3 {

            SVProgressHUD.show()
            SVProgressHUD.setMinimumDismissTimeInterval(1)
            //清空存储器缓存
            KingfisherManager.shared.cache.clearMemoryCache()
            //清空磁盘缓存
            KingfisherManager.shared.cache.clearDiskCache()
            //清空失效和过大的缓存
            KingfisherManager.shared.cache.cleanExpiredDiskCache()
            
    
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                SVProgressHUD.showSuccess(withStatus: "清除缓存成功")
                self.tableView.reloadData()
            })
        }
    }
}



// MARK: - 初始化视图
extension SettingViewController {
    
    func setup() {
        
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

        
        
    }

}
