//
//  CourierPhoneCell.m
//  快易查
//
//  Created by 刘超正 on 2017/11/18.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "CourierPhoneCell.h"

@implementation CourierPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //快递名称
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        //快递电话
        self.tel = [[UILabel alloc]init];
        [self.contentView addSubview:self.tel];
       // [self.tel setTextColor:RGBColor(231, 231, 236, 1)];
        //设置约束
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.height.equalTo(@40);
        }];
        [self.tel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(5);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-10);
           // make.height.equalTo(@20);
        }];
    }
    return self;
}
-(void)setModel:(CourierPhoneModel *)model{
    self.title.text = model.name;
    self.tel.text = model.tel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
