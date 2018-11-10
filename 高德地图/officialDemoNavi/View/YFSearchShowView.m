//
//  YFSearchShowView.m
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "YFSearchShowView.h"

@implementation YFSearchShowView
//创建
+ (instancetype)createShowView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"YFSearchShowView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    for (UIButton *btn in self.btns) {
        
        [[btn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    self.layer.cornerRadius = 5;
    //阴影
    self.layer.cornerRadius = 5;
    self.layer.shadowOpacity = 0.5;// 阴影透明度
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    self.layer.shadowRadius = 3;// 阴影扩散的范围控制
}

//点击事件
- (IBAction)clickBtns:(UIButton *)sender {
    
    NSString *str = @"美食";
    switch (sender.tag) {
        case 0:
            str = @"美食";
            break;
        case 1:
            str = @"景点";
            break;
        case 2:
            str = @"酒店";
            break;
        case 3:
            str = @"休闲娱乐";
            break;
        case 4:
            str = @"汽修";
            break;
        default:
            break;
    }
    //传递
    self.searchBlock(str);
}
@end
