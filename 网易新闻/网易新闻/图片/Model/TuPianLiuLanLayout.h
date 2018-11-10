//
//  TuPianLiuLanLayout.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义协议
@class TuPianLiuLanLayout;
@protocol TuPianLiuLanLayoutDelegate <NSObject>
//必须实现
@required
// 返回index位置下的item的高度
- (CGFloat)waterFallLayout:(TuPianLiuLanLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width;

@optional
// 返回瀑布流显示的列数
- (NSUInteger)columnCountOfWaterFallLayout:(TuPianLiuLanLayout *)waterFallLayout;
// 返回行间距
- (CGFloat)rowMarginOfWaterFallLayout:(TuPianLiuLanLayout *)waterFallLayout;
// 返回列间距
- (CGFloat)columnMarginOfWaterFallLayout:(TuPianLiuLanLayout *)waterFallLayout;
// 返回边缘间距
- (UIEdgeInsets)edgeInsetsOfWaterFallLayout:(TuPianLiuLanLayout *)waterFallLayout;
@end
@interface TuPianLiuLanLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<TuPianLiuLanLayoutDelegate> delegate;
@end
