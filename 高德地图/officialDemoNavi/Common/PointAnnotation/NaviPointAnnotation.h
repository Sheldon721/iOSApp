//
//  NaviPointAnnotation.h
//  AMapNaviKit
//
//  Created by李晓东 on 17/10/12.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, NaviPointAnnotationType)
{
    NaviPointAnnotationStart,
    NaviPointAnnotationWay,
    NaviPointAnnotationEnd
};

@interface NaviPointAnnotation : MAPointAnnotation

@property (nonatomic, assign) NaviPointAnnotationType navPointType;

@end
