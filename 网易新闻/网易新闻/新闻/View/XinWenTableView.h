//
//  XinWenTableView.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinWenCell.h"
#import "XinWenTwoCell.h"
@interface XinWenTableView : UITableView

//通过工厂方法  表视图创建
+ (instancetype)tableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>)delegate;
@end
