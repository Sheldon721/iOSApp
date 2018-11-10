//
//  TableViewDelagate.h
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendSpecialDeliveryViewController.h"
#import "QueryCourierViewController.h"
#import "CourierPhoneViewController.h"
@interface TableViewDelagate : NSObject<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate>

/** 寄快递控制器 */
@property(nonatomic,strong) SendSpecialDeliveryViewController *sendSpecialDeliveryTableView;
/** 查询快递控制器 */
@property(nonatomic,strong) QueryCourierViewController *queryCourierTableView;
/** 快递电话控制器 */
@property(nonatomic,strong) CourierPhoneViewController *courierPhoneTableView;
@end
