//
//  CachedImages.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/17.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedImage : NSObject
@property (copy, nonatomic) NSString* url;
@property (copy, nonatomic) NSString* fileName;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)cachedImageWithDic:(NSDictionary*)dic;
@end
