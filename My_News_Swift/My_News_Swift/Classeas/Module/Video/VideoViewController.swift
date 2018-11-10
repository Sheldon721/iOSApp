//
//  VideoViewController.swift
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import SVProgressHUD
class VideoViewController: UIViewController {
    
    
    var tableView = UITableView()
    
    var items = NSArray()
    
    var player = LGPlayer()
    
    let header = MJRefreshNormalHeader()
    
    var type = "VAP4BFE3U"
    
    var statusBarHidden = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIApplication.shared.addObserver(self, forKeyPath: "statusBarOrientation", options: .new, context: nil)
        
        
//        if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft {
//
//
//        }else if  UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight {
//
//
//        } else{
//
//
//        }
        
        setup()
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                setCustomNavigationBar()
        self.navigationItem.titleView = titleView
        titleView.selectType(index: 0)
        for view in (Window?.subviews)! {
            if view.isKind(of: UIButton.classForCoder()) {
                view.isHidden = true
            }
        }

    }


    func setup(){
         setCreateTableView()
         setRefresh()
         self.tableView.mj_header.beginRefreshing()
    }
    
    lazy var titleView : TitleView = {
       var titleView = TitleView()
        titleView.delegate = self
        let w = (Kwidth / 1.8)
        titleView.frame = CGRect.init(x: 0, y: 0, width:w , height: 40)
        return titleView
    }()
    
    func setCreateTableView() {
        
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(VideoTableViewCell.classForCoder(), forCellReuseIdentifier: VideoTableViewCell.identfier!)
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        
       
    }
    
    func setRefresh() {
        
        header.setRefreshingTarget(self, refreshingAction: #selector(fetchLoadingData))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        self.tableView.es_footer?.startRefreshing(isAuto: true)
        
    }
}

//MARK: 获取数据
extension VideoViewController : titleNavDelegate  {
    
    
    
    func didTitleNavTouchIdUpinside(key: String) {
        
        self.player.removePlayer()
        self.type = key
        print("点击  ",type)
        self.tableView.mj_header.beginRefreshing()
    }
    
    
 
    
    
    @objc func fetchLoadingData() {
    
        
        ApiManager.shareNetworkTool.sendVideoHttp(key:type) { (response) in
            self.tableView.mj_header.endRefreshing()
            let arrayM = NSMutableArray()
            for dict in response.restltArray! {
                arrayM.add(VideoModel.init(dict: dict as! [String : AnyObject]))
            }
            self.items = arrayM
            self.tableView.reloadData()
        }

    }
    
    
}

extension VideoViewController : UITableViewDelegate , UITableViewDataSource ,LGPlayerDelegate{
    func fullDidTouchUpInsise(MP4HdUrl: String, MP4URL: String, row: Int, PlayingTime: Double, titleName: String, isfull: Bool) {
        print("显示样式---- ",MP4URL,MP4HdUrl,row,isfull)
        guard isfull else {
            // 正常模式
            addPlayer(section: row ,currtenTime: PlayingTime)
            return
        }
        // 全屏
        if MP4HdUrl == "" {
            SVProgressHUD.showError(withStatus: "视频不支持横屏 ～ ")
            return
        }
        self.player.removePlayer()
        self.player = LGPlayer.init(frame: CGRect.init(x: -146, y: 146, width:Kheight, height: Kwidth))
        self.player.delegate = self

        self.player.indexRow = row
        self.player.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi / 2))
        self.player.playHD(MP4HdUrl: MP4HdUrl, MP4URL: MP4URL ,currtenTime: PlayingTime , titleName: titleName)
    
        Window?.addSubview(player)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = VideoTableViewCell()
        let model = self.items[indexPath.section] as! VideoModel
        cell.model = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        addPlayer(section: indexPath.section ,currtenTime: 0)
    }
    
    //  添加视频layer层
    
    func addPlayer(section : Int , currtenTime : Double) {
        
        if self.player.subviews.count > 1 {
            self.player.removePlayer()
        }
        
        
        let originY = 265 * section
        
        self.player = LGPlayer.init(frame: CGRect.init(x: 0, y: originY, width: Int(Kwidth), height: 217))
        self.player.PlaySD(currtenTime: currtenTime)
        self.player.delegate = self
        self.player.model = self.items[section] as? VideoModel
        self.player.indexRow = section
        self.tableView.addSubview(self.player)
        
    }
    
    
}
