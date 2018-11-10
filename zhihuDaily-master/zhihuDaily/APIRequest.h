//
//  APiRequest.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject
+ (void)requestWithUrl:(NSString*)url;
+ (void)requestWithUrl:(NSString*)url completion:(void (^)(id data, NSString* md5))completion;

+ (NSDictionary*)objToDic:(id)object;
@end
