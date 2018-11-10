//
//  TuPianCaoZuoViewController.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/9.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuPianModel.h"
@interface TuPianCaoZuoViewController : UIViewController
@property (nonatomic,copy) NSMutableArray *tuPianAry;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) TuPianModel *model;
@end
