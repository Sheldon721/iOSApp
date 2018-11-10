//
//  SliderView.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/19.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderViewDataSource<NSObject>
@required
/**
 *  指定Slider的项目数
 *
 *  @return return value description
 */
- (NSUInteger)numberOfItemsInSliderView;

@optional
/**
 *  指定索引位置的图片
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIImage*)imageForSliderAtIndex:(NSInteger)index;
/**
 *  指定索引位置的标题
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)titleForSliderAtIndex:(NSInteger)index;
/**
 *  指定索引位置的副标题
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)subTitleForSliderAtIndex:(NSInteger)index;
/**
 *  指定索引位置的事件
 *
 *  @param index <#index description#>
 */
- (void)touchUpForSliderAtIndex:(NSInteger)index;
@end

@interface SliderView : UIView
@property (weak, nonatomic) id<SliderViewDataSource> dataSource;
@property (assign, nonatomic) NSTimeInterval interval;

@property (assign, nonatomic) NSInteger contentInsetY;
/**
 *  构建SliderView
 */
- (void)buildSliderView;

- (void)stopSliding;
- (void)startSliding;

/**
 *  设定索引位置的图片
 *
 *  @param index <#index description#>
 */
- (void)setImage:(UIImage*)image atIndex:(NSUInteger)index;
@end
