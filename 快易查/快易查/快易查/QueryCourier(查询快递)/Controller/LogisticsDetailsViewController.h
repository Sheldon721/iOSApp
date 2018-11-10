//
//  LogisticsDetailsViewController.h
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsDetailsViewController : UIViewController

/** 模型数组 */
@property(nonatomic,strong) NSMutableArray *modelAry;

/** tableView */
@property(nonatomic,strong) UITableView *tableView;
@end
