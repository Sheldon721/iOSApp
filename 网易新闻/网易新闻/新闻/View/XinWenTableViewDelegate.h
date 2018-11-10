//
//  XinWenTableViewDelegate.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "XinWenCell.h"
#import "XinWenTwoCell.h"
#import "XinWenViewController.h"
@interface XinWenTableViewDelegate : NSObject<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic ,strong)XinWenViewController *xwC;//新闻控制器对象
@property (nonatomic,copy) NSMutableArray *modelAry;//模型对象
@end
