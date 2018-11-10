//
//  RouteCollectionViewCell.h
//  AMapNaviKit
//
//  Created by李晓东 on 17/10/12.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCollectionViewInfo : NSObject

@property (nonatomic, assign) NSInteger routeID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@interface RouteCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) RouteCollectionViewInfo *info;

@property (nonatomic, assign) BOOL shouldShowPrevIndicator;
@property (nonatomic, assign) BOOL shouldShowNextIndicator;

@end
