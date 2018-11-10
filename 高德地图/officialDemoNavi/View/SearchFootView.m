//
//  SearchFootView.m
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "SearchFootView.h"

@implementation SearchFootView

+ (instancetype)createFootView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"SearchFootView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    //添加一个点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
    [self addGestureRecognizer:tap];
    
    //阴影
    self.layer.cornerRadius = 5;
    self.layer.shadowOpacity = 0.5;// 阴影透明度
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    self.layer.shadowRadius = 3;// 阴影扩散的范围控制
}

//事件
- (void)clickView{
    
    self.searchRoundBlock();
}
@end
