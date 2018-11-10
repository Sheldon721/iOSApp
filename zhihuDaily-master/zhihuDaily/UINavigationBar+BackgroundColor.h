//
//  UINavigationBar+BackgroundColor.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/22.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)
/**
 *  设置navigationbar的背景色
 *
 *  @param color <#color description#>
 */
- (void)setNavigationBackgroundColor:(UIColor*)color;
/**
 *  设置navigationbar的背景宽度
 *
 *  @param height <#height description#>
 */
- (void)setBackgroundLayerHeight:(CGFloat)height;
@end
