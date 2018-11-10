//
//  Stories.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stories : NSObject

@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* ga_prefix;
@property (copy, nonatomic) NSArray* images;
@property (strong, nonatomic) NSString* image;
@property (assign, nonatomic) NSUInteger type;
@property (assign, nonatomic) NSUInteger identidier;
@property (assign, nonatomic) BOOL multipic;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)storiesWithDic:(NSDictionary*)dic;
+ (NSArray<Stories*>*)stories:(NSArray*)array;

@end
