//
//  PersonalCenterCell.h
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterCell : UITableViewCell
/** 标题 */
@property(nonatomic,strong) UILabel *title;
/** 图标 */
@property(nonatomic,strong) UIImageView *postingImgV;
/** 分割线 */
@property(nonatomic,strong) UIView *dividingLine;
@end
