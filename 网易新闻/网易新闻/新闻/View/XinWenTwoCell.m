//
//  XinWenTwoCell.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/9.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenTwoCell.h"

@implementation XinWenTwoCell
{
    UILabel *_title;
    UILabel *_time;
    UIView *_bottomView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc]init];
        _title.numberOfLines = 0;
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];
        
        _time = [[UILabel alloc]init];
        _time.numberOfLines = 0;
        _time.font = [UIFont systemFontOfSize:10];
        _time.textColor = [UIColor blackColor];
        [self.contentView addSubview:_time];
        
        _bottomView = [[UIView alloc]init];
        [self.contentView addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
        
        _title.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 15).autoHeightRatio(0);
        _time.sd_layout.leftEqualToView(_title).topSpaceToView(_title, 20).rightSpaceToView(self.contentView, 20).autoHeightRatio(0);
        _bottomView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 0).topSpaceToView(_time, 10).heightIs(1);
        
        
        [self setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
    }
    return self;
}
-(void)setModel:(XinWenModel *)model{
    _model = model;
    _title.text = _model.title;
    _time.text = _model.time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
