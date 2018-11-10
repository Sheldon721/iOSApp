//
//  PingLunCell.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PingLunModel.h"
@interface PingLunCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *imgV;//头像
@property (nonatomic ,strong) UILabel *title;//昵称
@property (nonatomic ,strong) UILabel *content;//内容
@property (nonatomic ,strong) UIView *fenGeXian;//分割线
@property (nonatomic ,strong) PingLunModel *model;
@end
