//
//  GradientView.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/17.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()
@end

@implementation GradientView
#pragma mark - initialization
- (instancetype)init
{
    if (self = [super init]) {
        return [self initWithFrame:CGRectZero];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //不加这一句自动布局约束要报错
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}

#pragma mark -
- (CAGradientLayer*)gradientLayer
{
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.frame;
        _gradientLayer.borderWidth = 0;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                             (id)[[UIColor clearColor] CGColor],
                                         (id)[[UIColor colorWithWhite:0 alpha:0.85] CGColor], nil];
        _gradientLayer.locations = @[ [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0] ];
    }
    return _gradientLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //得用这个才能调整渐变层的大小
    //刚才在外部bounds™的不是0么。。
    self.gradientLayer.frame = self.bounds;
}

@end
