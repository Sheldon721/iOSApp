//
//  StoriesHeaderView.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/21.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "MainViewController.h"
#import "StoriesHeaderCell.h"

@interface StoriesHeaderCell ()
@property (strong, nonatomic) UILabel* label;

@end

@implementation StoriesHeaderCell
- (UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (void)setText:(NSString*)text
{
    if (_text != text) {
        _text = [text copy];
        [self buildHeaderView];
    }
}

- (void)buildHeaderView
{
    self.backgroundColor = [MainViewController themeColor];
    self.label.frame = self.frame;
    self.label.text = self.text;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];

    [self addSubview:self.label];
}
@end
