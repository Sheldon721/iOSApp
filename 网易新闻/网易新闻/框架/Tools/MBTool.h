//
//  MBTool.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTool : NSObject
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
@end
