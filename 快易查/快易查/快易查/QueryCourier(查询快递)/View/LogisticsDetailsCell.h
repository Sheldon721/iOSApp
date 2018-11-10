//
//  LogisticsDetailsCell.h
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryCourierModel.h"
@interface LogisticsDetailsCell : UITableViewCell
/** 时间 */
@property(nonatomic,strong) UILabel *time;
/** 物流状态 */
@property(nonatomic,strong) UILabel *status;

/** 模型 */
@property(nonatomic,strong) QueryCourierModel *model;

/** 直线 */
@property(nonatomic,strong) UIView *straightLine;
/** 小圆点 */
@property(nonatomic,strong) UIView *dot;

@end
