//
//  XInWenNaviCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/30.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XInWenNaviCell.h"

@implementation XInWenNaviCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置视图
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _naviView.layer.cornerRadius = 10;
        _naviView.layer.borderWidth = 1;
        _naviView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
        [self.contentView addSubview:_naviView];
        //设置文字
        _naviLbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 40, 40)];
        [self.contentView addSubview:_naviLbl];
    }
    return self;
}
@end
