//
//  PingLunCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "PingLunCell.h"

@implementation PingLunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.imgV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgV];
        //昵称
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        //内容
        self.content = [[UILabel alloc]init];
        [self.contentView addSubview:self.content];
        //分割线
        self.fenGeXian = [[UIView alloc]init];
        [self.contentView addSubview:self.fenGeXian];
        self.fenGeXian.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
        //设置Frame
        self.imgV.sd_layout.topSpaceToView(self.contentView, 5).leftSpaceToView(self.contentView, 5).heightIs(40).widthIs(40);
        self.imgV.layer.cornerRadius = 20;
        self.imgV.layer.masksToBounds = YES;
        self.title.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.imgV, 2).rightSpaceToView(self.contentView, 100).autoHeightRatio(0);
        self.content.sd_layout.topSpaceToView(self.title, 20).leftSpaceToView(self.imgV, 2).rightSpaceToView(self.contentView, 100).autoHeightRatio(0);
        self.fenGeXian.sd_layout.topSpaceToView(self.content, 10).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1);
        
        [self setupAutoHeightWithBottomView:self.fenGeXian bottomMargin:0];
    }
    return self;
}

- (void)setModel:(PingLunModel *)model{
    _model = model;
    self.title.text = _model.name;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"user_defaultavatar@2x.png"]];
    self.content.text = _model.content;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
