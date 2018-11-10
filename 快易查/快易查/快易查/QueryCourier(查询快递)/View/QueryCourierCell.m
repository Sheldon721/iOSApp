//
//  QueryCourierCell.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "QueryCourierCell.h"

@implementation QueryCourierCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景视图
        self.backView = [[UIView alloc]init];
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor whiteColor];
        //运单号输入框
        self.waybillBox = [[UITextField alloc]init];
        [self.backView addSubview:self.waybillBox];
        [self.waybillBox setPlaceholder:@"请输入运单号查询快件信息"];
        //查询按钮
        self.enquiries = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.enquiries];
        [self.enquiries setTitle:@"查询" forState:UIControlStateNormal];
        self.enquiries.backgroundColor = RGBColor(199, 199, 199, 1);
        self.enquiries.enabled = NO;
        //分割线
        self.dividingLine = [[UIView alloc]init];
        [self.contentView addSubview:self.dividingLine];
        self.dividingLine.backgroundColor = RGBColor(239, 238, 242, 1);
        
        //设置约束
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.equalTo(@50);
        }];
        [self.waybillBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.backView);
            make.left.equalTo(self.backView).offset(10);
        }];
        [self.enquiries mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.waybillBox.mas_bottom).offset(30);
            make.left.right.equalTo(self.backView);
            make.height.equalTo(@50);
        }];
        [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.contentView);
            make.height.equalTo(@10);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
