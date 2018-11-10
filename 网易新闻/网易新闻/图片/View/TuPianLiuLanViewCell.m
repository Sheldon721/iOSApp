//
//  TuPianLiuLanViewCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "TuPianLiuLanViewCell.h"

@implementation TuPianLiuLanViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgV];
        self.title = [[UILabel alloc]init];
        [self.title setTextAlignment:NSTextAlignmentCenter];
        self.title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.title setTextColor:[UIColor whiteColor]];
        [self.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [self.contentView addSubview:self.title];
    }
    return self;
}

- (void)setModel:(TuPianModel *)model{
    _model = model;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_model.small_url] placeholderImage:[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    self.imgV.frame = CGRectMake(0, 0, self.frame.size.width, [_model.small_height floatValue]);
    
    self.title.text = _model.title;
    self.title.frame = CGRectMake(0, [_model.small_height floatValue]-30, self.frame.size.width, 30);

}
@end
