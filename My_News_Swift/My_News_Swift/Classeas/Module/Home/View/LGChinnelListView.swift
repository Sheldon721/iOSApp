//
//  LGChinnelListView.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/3.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SVProgressHUD
private let itemW: CGFloat = (Kwidth - 60) / 4
class LGChinnelListView: UIView {

    let headerTitle = [["我的频道", "更多频道"], ["拖动频道排序", "点击添加频道"]]
    
    var collectionView : UICollectionView?
    
    var isEdit = false
    
    var myChannelArray = [String]()
    
    var moreChannelArray = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        reloadDatas()
        
    }
    
    func reloadDatas() {
        myChannelArray = self.itemsTitleM() as! [String]
        moreChannelArray  = self.itemsSelectMM() as! [String]
        self.collectionView?.reloadData()
    }
    
    func reloadData(myChannel: [String], moreChannel: [String]){
        
        myChannelArray = self.itemsTitleM() as! [String]
        moreChannelArray  = self.itemsSelectMM() as! [String]
        
        print(myChannel,moreChannel)

        UIView.animate(withDuration: 0.5) {
            self.collectionView?.frame = CGRect.init(x: 0, y: 0, width: 375, height: self.frame.height)
        }
        self.collectionView?.reloadData()
        
    }
    
    func setup() {
        
        let LGChannelListViewLayout = UICollectionViewFlowLayout()
        LGChannelListViewLayout.headerReferenceSize = CGSize.init(width: Kwidth, height: 44)
        LGChannelListViewLayout.itemSize = CGSize.init(width: itemW, height: itemW * 0.4)
        LGChannelListViewLayout.minimumInteritemSpacing = 8
        LGChannelListViewLayout.minimumLineSpacing = 8
        LGChannelListViewLayout.sectionInset = UIEdgeInsets.init(top: 10, left:10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView.init(frame: self.frame, collectionViewLayout: LGChannelListViewLayout)
        UIView.animate(withDuration: 0.5) {
            collectionView.frame = CGRect.init(x: 0, y: 0, width: 375, height: self.frame.height)
        }
        
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ChinnalListCell.classForCoder(), forCellWithReuseIdentifier: ChinnalListCell.identfier! as String)
        collectionView.register(LGChinnelListHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: (LGChinnelListHeadView.identfier)!)
//
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        collectionView.addGestureRecognizer(gesture)
        
        self.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    



    
}

extension LGChinnelListView : UICollectionViewDelegate , UICollectionViewDataSource , LGChinnelListHeadViewDelagate,LGChinnelListViewCellDelegate{
    
    func deleteChinnel(row: Int) {
        // 删除
        print(myChannelArray.count)
        if myChannelArray.count <= 6 {
            SVProgressHUD.showError(withStatus: "栏目不能少于6个 ～～")
            return
        }
        let deleteTitle = myChannelArray.remove(at: row)
        moreChannelArray.append(deleteTitle)
        let array = moreChannelArray as NSArray
        let arrayM = myChannelArray as NSArray
        
        array.write(toFile: fetchHomeHomeSelectTitlePath(), atomically: true)
        arrayM.write(toFile: fetchHomeTitlePath(), atomically: true)
        self.collectionView?.reloadData()
        self.collectionView?.reloadData()
    }
    
    func editTouchUpInside(isSelected: Bool) {
        self.isEdit = isSelected
        self.collectionView?.reloadData()
    }
    
    
    
    
    // MARK: - 手势 拖拽
    @objc func longPress(tap: UILongPressGestureRecognizer) -> () {
        

        let point = tap.location(in: tap.view)
        let sourceIndexPath = collectionView?.indexPathForItem(at: point)
        
        switch tap.state {
        case UIGestureRecognizerState.began:
            collectionView?.beginInteractiveMovementForItem(at: sourceIndexPath!)
            
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(point)
            
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
            
        case UIGestureRecognizerState.cancelled:
            collectionView?.cancelInteractiveMovement()
        default:
            break
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LGChinnelListHeadView.identfier!, for: indexPath) as! LGChinnelListHeadView
        headView.delegate = self
        var titleA = isEdit == false ? headerTitle[0] : headerTitle[1]
        headView.title = titleA[indexPath.section]
        headView.indexPathRow = indexPath.section
        headView.editIsSelected(selected: self.isEdit)
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.myChannelArray.count : self.moreChannelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChinnalListCell.identfier! as String, for: indexPath) as! ChinnalListCell

        guard indexPath.section == 0 else {
            cell.titleTwo = self.moreChannelArray[indexPath.row]
            cell.reloadSetUI(isSelect: self.isEdit, section: indexPath.section)
            return cell
        }
        cell.row = indexPath.row
        cell.delegate = self
        cell.reloadSetUI(isSelect: self.isEdit, section: indexPath.section)
        cell.titleOne = self.myChannelArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEdit {
            if indexPath.section == 0 {
            }else {
                // 添加栏目
                let title = moreChannelArray[indexPath.row]
                moreChannelArray.remove(at: indexPath.row)
                myChannelArray.append(title)
                let array = moreChannelArray as NSArray
                let arrayM = myChannelArray as NSArray
                array.write(toFile: fetchHomeHomeSelectTitlePath(), atomically: true)
                arrayM.write(toFile: fetchHomeTitlePath(), atomically: true)
                self.collectionView?.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
            
            let obj = self.myChannelArray[sourceIndexPath.item]
            myChannelArray.remove(at: sourceIndexPath.item)
            myChannelArray.insert(obj, at: destinationIndexPath.item)
            let array = myChannelArray as NSArray
            array.write(toFile: fetchHomeTitlePath(), atomically: true)
            
        } else if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1){
            let obj = myChannelArray[sourceIndexPath.item]
            myChannelArray.remove(at: sourceIndexPath.item)
            moreChannelArray.insert(obj, at: destinationIndexPath.item)
            let array = myChannelArray as NSArray
            let arrayM = moreChannelArray as NSArray
            array.write(toFile: fetchHomeTitlePath(), atomically: true)
            arrayM.write(toFile: fetchHomeHomeSelectTitlePath(), atomically: true)
            
        }
        if sourceIndexPath.section == 1 && destinationIndexPath.section == 0 {
            let obj = moreChannelArray[sourceIndexPath.item]
            moreChannelArray.remove(at: sourceIndexPath.item)
            myChannelArray.insert(obj, at: destinationIndexPath.item)
            let array = myChannelArray as NSArray
            let arrayM = moreChannelArray as NSArray
            array.write(toFile: fetchHomeTitlePath(), atomically: true)
            arrayM.write(toFile: fetchHomeHomeSelectTitlePath(), atomically: true)
        }
        if sourceIndexPath.section == 1 && destinationIndexPath.section == 1 {
            let obj = moreChannelArray[sourceIndexPath.item]
            moreChannelArray.remove(at: sourceIndexPath.item)
            moreChannelArray.insert(obj, at: destinationIndexPath.item)
            let arrayM = moreChannelArray as NSArray
            arrayM.write(toFile: fetchHomeHomeSelectTitlePath(), atomically: true)
        }

    }
    
    // 可操作 UICollectionView
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.item == 0 {
            return false
        }
        return true
    }
    
    
    func fetchHomeTitlePath()-> String {
        
        return "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/HomeTitle.plist"
    }
    
    func fetchHomeHomeSelectTitlePath() -> String {
        return "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/HomeSelectTitle.plist"
    }
    func itemsSelectMM() -> NSArray {
        
        var items = NSArray()
        let cachePath = "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/HomeSelectTitle.plist"
        
        
        items = NSArray.init(contentsOfFile: cachePath)!
        var arrayM = NSMutableArray()
        for array in items  {
            arrayM.add(array)
        }
        
        return arrayM
    }
    func itemsTitleM() -> NSArray {
        
        var items = NSArray()
        let cachePath = "/Users/lg/Desktop/Me-News/Swift/My_News_Swift/My_News_Swift/HomeTitle.plist"
        
        
        items = NSArray.init(contentsOfFile: cachePath)!
        var arrayM = NSMutableArray()
        for array in items  {
            arrayM.add(array)
        }
        
        return arrayM
    }
}
