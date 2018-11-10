//
//  HeaderView.h
//  云音乐
//
//  Created by 李晓东 on 2017/9/20.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic,strong)UILabel *MLLbl;
@property (nonatomic,strong)UISearchBar *SearchB;
+ (instancetype)initWithViewFrame:(CGRect)frame;
@end
