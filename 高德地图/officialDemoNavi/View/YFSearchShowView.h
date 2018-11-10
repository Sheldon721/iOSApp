//
//  YFSearchShowView.h
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSearchShowView : UIView
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;//按钮
@property(nonatomic,copy)void(^searchBlock)(NSString *str);//搜索
+ (instancetype)createShowView;//创建
//点击事件
- (IBAction)clickBtns:(UIButton *)sender;

@end
