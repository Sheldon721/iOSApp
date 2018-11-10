
//  MyView.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/19.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import MJRefresh
protocol MyViewDelegate : NSObjectProtocol {
    
    func updateRefresh(tag : NSInteger)
    
    func didTouchUpInside(url : String , homeModol:HomeDataModel)
    
}

class MyView: UIView {
    
    var delegate : MyViewDelegate?
    
    let header = MJRefreshNormalHeader()
    
    var items = Array<AnyObject>(
    )
    var tableView = UITableView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        self.tableView.es_footer?.startRefreshing(isAuto: true)
    }
    func beginRefreshing() {
        self.tableView.mj_header.beginRefreshing()
        print("---------beginRefreshing %ld",self.tag)
    }
    func endRefreshing() {
        self.tableView.mj_header.endRefreshing()
        print("---------endRefreshing")
    }
    
    @objc func headerRefresh() {
        self.delegate?.updateRefresh(tag: self.tag)
        print("---------headerRefresh %ld",self.tag)
    }
    
  
    func roloadData(items : Array<AnyObject>){
        
        self.items = items;
        print(self.items.count);
        self.tableView.reloadData()
        
    }
    
    
    func setup(){
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(HomeNewsSingleCell.classForCoder(), forCellReuseIdentifier:HomeNewsSingleCell.identfier!)
        
        tableView.register(HomeNewsMoreCell.classForCoder(), forCellReuseIdentifier: HomeNewsMoreCell.identfier!)
        self.addSubview(tableView)
        self.tableView = tableView;
        print(self.frame.size.height - 44)
        tableView.frame = CGRect.init(x: 0, y: 0, width: Kwidth, height: CGFloat(Kheight) - CGFloat(157))
        
        

    }
}

extension MyView : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.items[indexPath.row] as! HomeDataModel
        if model.UiStyle {
            return 90
        }
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 多张图片显示样式
        let model = self.items[indexPath.row] as! HomeDataModel
        print(model.UiStyle)
        guard model.UiStyle == false else {
            var cell = HomeNewsSingleCell()
        
            cell = tableView.dequeueReusableCell(withIdentifier: HomeNewsSingleCell.identfier!) as! HomeNewsSingleCell
            cell.items = self.items[indexPath.row] as? HomeDataModel
            return cell
        }
        
        var cell = HomeNewsMoreCell()
        cell = tableView.dequeueReusableCell(withIdentifier: HomeNewsMoreCell.identfier!) as! HomeNewsMoreCell
        cell.items = self.items[indexPath.row] as? HomeDataModel
   
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.items[indexPath.row] as! HomeDataModel
        print(model.url)
        self.delegate?.didTouchUpInside(url: model.url , homeModol: model)
    }
}
