//
//  StartImage.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "StartImage.h"

@implementation StartImage
- (instancetype)initWithDic:(NSDictionary*)dic
{
  if (self = [super init]) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}
+ (instancetype)startImageWithDic:(NSDictionary*)dic
{
  return [[StartImage alloc] initWithDic:dic];
}
@end
