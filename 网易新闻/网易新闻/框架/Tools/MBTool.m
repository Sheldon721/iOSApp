//
//  MBTool.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "MBTool.h"

@implementation MBTool
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.textColor = [UIColor whiteColor];
    // YES代表需要蒙版效果
    //hud.dimBackground = YES;
    //一秒消失
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}
@end
