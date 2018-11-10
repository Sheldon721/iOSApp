//
//  ShiPingFenLeiViewController.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/13.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiPingFenLeiViewController : UIViewController
@property (nonatomic ,strong) NSString * urlStr;
@property (nonatomic ,strong) NSMutableArray *fenLeiModelAry;
@property (nonatomic ,strong) FMDBTool *dbTool;
@end
