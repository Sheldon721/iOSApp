//
//  TuPianLiuLanViewCell.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuPianModel.h"
@interface TuPianLiuLanViewCell : UICollectionViewCell
@property (nonatomic ,strong) UIImageView *imgV;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) TuPianModel *model;
@end
