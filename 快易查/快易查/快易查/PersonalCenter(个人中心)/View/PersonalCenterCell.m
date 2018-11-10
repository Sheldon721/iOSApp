//
//  PersonalCenterCell.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "PersonalCenterCell.h"

@implementation PersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图标
        self.postingImgV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.postingImgV];
        //标题
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        //分割线
        self.dividingLine = [[UIView alloc]init];
        [self.contentView addSubview:self.dividingLine];
        self.dividingLine.backgroundColor = RGBColor(240, 220, 208, 1);
        
        //设置约束
        [self.postingImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@30);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.postingImgV);
            make.left.equalTo(self.postingImgV.mas_right).offset(10);
        }];
        [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
