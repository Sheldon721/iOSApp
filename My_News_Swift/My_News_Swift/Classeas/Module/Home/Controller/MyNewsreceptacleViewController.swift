//
//  HomeViewControllers.swift
//  My_News_Swift
//
//  Created by LG on 2017/10/19.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit

class MyNewsreceptacleViewController : UIViewController {

    var tableView = UITableView()
    
    var items = Array<AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = arc4randomColor()
        self.setup()
    }
    
    func setup(){
        
        var tableView = UITableView()
        tableView.backgroundColor = UIColor.blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView)
        self.tableView = tableView;
    }

}
extension MyNewsreceptacleViewController: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.items[indexPath.section] as! HomeDataModel
        
        guard model.UiStyle == true else {
            //  一张图片显示样式
            return UITableViewCell()
        }
        
        // 多张图片显示样式
        
        return UITableViewCell()
        
    }
    
}
