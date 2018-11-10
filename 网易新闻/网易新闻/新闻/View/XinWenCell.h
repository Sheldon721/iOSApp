//
//  XinWenCell.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/8.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinWenModel.h"
@interface XinWenCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *imgV;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)XinWenModel *model;
@property (nonatomic,strong)UIView  *bottomView;
@end
