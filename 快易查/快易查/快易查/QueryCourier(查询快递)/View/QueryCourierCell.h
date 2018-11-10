//
//  QueryCourierCell.h
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryCourierCell : UITableViewCell
/** 背景视图 */
@property(nonatomic,strong) UIView *backView;
/** 运单号输入框 */
@property(nonatomic,strong) UITextField *waybillBox;
/** 查询按钮 */
@property(nonatomic,strong) UIButton *enquiries;
/** 分割线 */
@property(nonatomic,strong) UIView *dividingLine;
@end
