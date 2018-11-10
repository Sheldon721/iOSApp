//
//  XinWenCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/8.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenCell.h"

@implementation XinWenCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.numberOfLines = 0;
        self.title.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.title];
        
        self.imgV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgV];
       // self.imgV.backgroundColor = [UIColor redColor];
        
        self.time = [[UILabel alloc]init];
        self.time.font = [UIFont systemFontOfSize:10];
        self.time.textColor = [UIColor blackColor];
        self.time.numberOfLines = 0;
        [self.contentView addSubview:self.time];
        
        self.bottomView = [[UIView alloc]init];
        [self.contentView addSubview:self.bottomView];
        self.bottomView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
        
        self.imgV.sd_layout.topSpaceToView(self.contentView, 15).leftSpaceToView(self.contentView, 15).heightIs(60).widthIs(60);
        self.title.sd_layout.topEqualToView(self.imgV).leftSpaceToView(self.imgV, 15).rightSpaceToView(self.contentView, 20).autoHeightRatio(0);
        self.time.sd_layout.bottomEqualToView(self.imgV).leftSpaceToView(self.imgV, 15).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
        self.bottomView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 0).topSpaceToView(self.time, 10).heightIs(1);
        
        
        [self setupAutoHeightWithBottomView:self.bottomView bottomMargin:0];
    }
    return self;
}
- (void)setModel:(XinWenModel *)model{
    _model = model;
    self.title.text = _model.title;
    self.time.text = _model.time;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@"tabbar_picture@3x.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
