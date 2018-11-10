//
//  FaChuCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/24.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "FaChuCell.h"

@implementation FaChuCell

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
        self.imgV.sd_layout.topSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, 10).widthIs(40).heightIs(40);
        //[self.imgV sd_setImageWithURL:[NSURL URLWithString:[_user objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"user_defaultavatar@2x.png"]];
        self.imgV.layer.cornerRadius = 20;
        self.imgV.layer.masksToBounds = YES;
        //昵称
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        self.title.sd_layout.topSpaceToView(self.contentView, 20).rightSpaceToView(self.imgV, 10).leftSpaceToView(self.contentView, 100);
        [self.title setTextAlignment:NSTextAlignmentRight];
        //内容
        self.neiROng = [[UILabel alloc]init];
        [self.contentView addSubview:self.neiROng];
        [self.neiROng setTextAlignment:NSTextAlignmentRight];
        [self.neiROng setFont:[UIFont systemFontOfSize:20]];
        self.neiROng.layer.cornerRadius = 25;
        self.neiROng.sd_layout.leftSpaceToView(self.contentView, 20).rightSpaceToView(self.imgV, 10).autoHeightRatio(0).topSpaceToView(self.title, 10);
        //底View
        UIView *footerView = [[UIView alloc]init];
        [self.contentView addSubview:footerView];
        footerView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 0).topSpaceToView(self.neiROng, 10).heightIs(1);
        [self setupAutoHeightWithBottomView:footerView bottomMargin:0];
    }
    return self;
}
- (void)setModel:(WenDaModel *)model{
    _model = model;
    self.neiROng.text = _model.content;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.title.text = [user objectForKey:@"Name"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"user_defaultavatar@2x.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
