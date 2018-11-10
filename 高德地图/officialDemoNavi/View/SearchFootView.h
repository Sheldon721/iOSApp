//
//  SearchFootView.h
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//地址
@property(nonatomic,copy)void(^searchRoundBlock)(void);//跳转
+ (instancetype)createFootView;//构造方法
@end
