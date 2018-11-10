//
//  StartImage.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StartImage : NSObject
@property (copy, nonatomic) NSString* img;
@property (copy, nonatomic) NSString* text;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)startImageWithDic:(NSDictionary*)dic;
@end
