//
//  SendSpecialDeliveryCell.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "SendSpecialDeliveryCell.h"

@implementation SendSpecialDeliveryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图标
        self.postingImgV = [[UIImageView alloc]init];
        //切圆角
        self.postingImgV.layer.cornerRadius = 20;
        self.postingImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.postingImgV];
        //文字
        self.imgViewTitle = [[UILabel alloc]init];
        [self.postingImgV addSubview:self.imgViewTitle];
        [self.imgViewTitle setTextColor:[UIColor whiteColor]];
        //地址
        self.address = [[UITextField alloc]init];
        [self.contentView addSubview:self.address];
        //分割线
        self.dividingLine = [[UIView alloc]init];
        [self.contentView addSubview:self.dividingLine];
        self.dividingLine.backgroundColor = RGBColor(242, 241, 242, 1);
        
        //设置约束
        [self.postingImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.width.equalTo(@40);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.postingImgV.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-30);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self.contentView);
            make.right.equalTo(self);
            make.height.equalTo(@1);
        }];
        [self.imgViewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.postingImgV);
            make.centerY.equalTo(self.postingImgV);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
