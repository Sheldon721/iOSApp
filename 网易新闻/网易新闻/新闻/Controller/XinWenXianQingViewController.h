//
//  XinWenXianQingViewController.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/13.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XinWenXianQingViewController : UIViewController
@property (nonatomic ,copy)NSIndexPath *indexPath;
@property (nonatomic ,strong)XinWenModel *model;
@property (nonatomic ,strong)FMDBTool *dbTool;
@end
