//
//  LogisticsDetailsCell.m
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LogisticsDetailsCell.h"

@implementation LogisticsDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //时间
        self.time = [[UILabel alloc]init];
        [self.contentView addSubview:self.time];
        self.time.numberOfLines = 0;
        //小圆点
        self.dot = [[UIView alloc]init];
        [self.contentView addSubview:self.dot];
        self.dot.backgroundColor = RGBColor(199, 199, 199, 1);
        self.dot.layer.cornerRadius = 7;
        self.dot.layer.masksToBounds = YES;
        //直线
        self.straightLine = [[UIView alloc]init];
        [self.contentView addSubview:self.straightLine];
        self.straightLine.backgroundColor = RGBColor(199, 199, 199, 1);
        //物流状态
        self.status = [[UILabel alloc]init];
        [self.contentView addSubview:self.status];
        self.status.numberOfLines = 0;
        
        //约束
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.equalTo(@90);
        }];
        [self.dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.time.mas_right).offset(20);
            make.width.height.equalTo(@14);
        }];
        [self.straightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dot.mas_bottom);
            make.left.equalTo(self.dot).offset(7);
            make.width.equalTo(@1);
            make.bottom.equalTo(self.contentView);
        }];
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.time);
            make.left.equalTo(self.dot.mas_right).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
         
    }
    return self;
}

- (void)setModel:(QueryCourierModel *)model{
    self.time.text = model.time;
    //设置行高
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.time.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.time.text length])];
    self.time.attributedText = attributedString;
    [self.time sizeToFit];
    //居中
    [self.time setTextAlignment:NSTextAlignmentCenter];
    
    //
    self.status.text = model.status;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
