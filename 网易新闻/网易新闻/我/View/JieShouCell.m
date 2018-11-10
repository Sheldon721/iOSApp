//
//  JieShouCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/24.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "JieShouCell.h"

@implementation JieShouCell

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
        self.imgV.sd_layout.topSpaceToView(self.contentView, 20).leftSpaceToView(self.contentView, 10).widthIs(40).heightIs(40);
        self.imgV.image = [UIImage imageNamed:@"user_defaultavatar@2x.png"];
        //昵称
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        self.title.sd_layout.topSpaceToView(self.contentView, 20).leftSpaceToView(self.imgV, 10).rightSpaceToView(self.contentView, 100);
        self.title.text = @"智能机器人 -小Q";
        //内容
        self.jieShou = [[UILabel alloc]init];
        [self.contentView addSubview:self.jieShou];
        [self.jieShou setTextAlignment:NSTextAlignmentLeft];
        [self.jieShou setFont:[UIFont systemFontOfSize:20]];
        self.jieShou.layer.cornerRadius = 25;
        self.jieShou.sd_layout.leftSpaceToView(self.imgV, 10).rightSpaceToView(self.contentView, 50).autoHeightRatio(0).topSpaceToView(self.title, 10);
        //底View
        UIView *footerView = [[UIView alloc]init];
        [self.contentView addSubview:footerView];
        footerView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 0).topSpaceToView(self.jieShou, 10).heightIs(1);
        [self setupAutoHeightWithBottomView:footerView bottomMargin:0];
    }
    return self;
}
- (void)setModel:(WenDaModel *)model{
    _model = model;
    self.jieShou.text = _model.content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
