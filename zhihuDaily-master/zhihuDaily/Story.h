//
//  Story.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject
@property (assign, nonatomic) NSUInteger id;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) NSString* css;
@property (copy, nonatomic) NSString* body;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* image;
@property (copy, nonatomic) NSString* imageSource;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)storyWithDic:(NSDictionary*)dic;
@end
