//
//  MoreMenuView.h
//  officialDemoNavi
//
//  Created by 李晓东 on 17/10/12.
//  Copyright (c) 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviCommonObj.h>

@protocol MoreMenuViewDelegate;

@interface MoreMenuView : UIView

@property (nonatomic, assign) id<MoreMenuViewDelegate> delegate;

@property (nonatomic, assign) AMapNaviViewTrackingMode trackingMode;
@property (nonatomic, assign) BOOL showNightType;

@end

@protocol MoreMenuViewDelegate <NSObject>
@optional

- (void)moreMenuViewFinishButtonClicked;
- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode;
- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType;

@end
