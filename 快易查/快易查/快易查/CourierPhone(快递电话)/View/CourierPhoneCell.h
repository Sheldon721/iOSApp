//
//  CourierPhoneCell.h
//  快易查
//
//  Created by 刘超正 on 2017/11/18.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourierPhoneModel.h"
@interface CourierPhoneCell : UITableViewCell
/** 快递名称 */
@property(nonatomic,strong) UILabel *title;
/** 快递电话 */
@property(nonatomic,strong) UILabel *tel;
/** 模型 */
@property(nonatomic,strong) CourierPhoneModel *model;
@end
