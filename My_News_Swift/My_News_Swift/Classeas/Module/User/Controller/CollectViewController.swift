//
//  CollectViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/12/19.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift
class CollectViewController: UIViewController {
    
    var tableView = UITableView()
    
    let realm = try! Realm()
    
    var items = Array<AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏"
        fetchLoadingData()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setBackNavigationBar()
        setCustomNavgitionBarRed()
    }
    
    func setup() {
        
        let tableview = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.showsVerticalScrollIndicator = true
        tableview.showsHorizontalScrollIndicator = true
        tableview.register(CollecViewCell.classForCoder(), forCellReuseIdentifier: CollecViewCell.identfier!)
        tableview.separatorStyle = .none
        
        self.view.addSubview(tableview)
        self.tableView = tableview
        self.tableView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }

    }
    
    
    func fetchLoadingData() {
        
        let status = self.realm.objects(HomeCollectModel.self)
        print(status.count)
        var arrayM = Array<AnyObject>()
        for i in 0..<status.count {
            let homeModel = status[i] as! HomeCollectModel
            if homeModel.isSelected {
                arrayM.append(homeModel)
            }else {
                print("已取消",homeModel.title)
            }
        }
        self.items = arrayM
        self.tableView.reloadData()
        
    }
    

}

extension CollectViewController : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CollecViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: CollecViewCell.identfier!) as! CollecViewCell
        cell.homeModel = self.items[indexPath.section] as! HomeCollectModel
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        var items = self.items[indexPath.section] as! HomeCollectModel
        
        var dataModel = HomeCollectModel()
        dataModel.isSelected = false
        dataModel.url = items.url
        dataModel.dataTime = items.dataTime
        dataModel.phone = items.phone
        dataModel.title = items.title
        dataModel.uniquekey = items.uniquekey
        
        
        try! self.realm.write {
            self.realm.add(dataModel, update: true)
        }
        self.items.remove(at: indexPath.section)
        tableView.deleteSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .bottom)
        
       
    }
    
    // 返回删除按钮标题
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏";
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // 默认就是删除样式
        return UITableViewCellEditingStyle.delete
    }

}
