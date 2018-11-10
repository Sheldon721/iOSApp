//
//  UIColor+Select.h
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Select)

+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha;
@end
