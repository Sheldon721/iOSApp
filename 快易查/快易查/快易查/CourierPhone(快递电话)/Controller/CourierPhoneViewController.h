//
//  CourierPhoneViewController.h
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierPhoneViewController : UIViewController
/** tableView */
@property(nonatomic,strong) UITableView *tableView;
/** 数组存储分组中的A~Z */
@property(nonatomic,strong) NSArray *sectionAry;
/** 模型字典数组 */
@property(nonatomic,strong) NSMutableDictionary *modelDict;

@end
