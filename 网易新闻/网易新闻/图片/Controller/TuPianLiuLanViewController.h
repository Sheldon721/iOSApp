//
//  TuPianLiuLanViewController.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuPianLiuLanViewController : UIViewController
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *tuPianAry;//查找出的图片数据
- (void)jiaZaiBenDiShuJu;
@end
