//
//  CachedImages.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/17.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "CachedImage.h"

@implementation CachedImage
- (instancetype)initWithDic:(NSDictionary*)dic
{
  self = [super init];
  if (self) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}

+ (instancetype)cachedImageWithDic:(NSDictionary*)dic
{
  return [[self alloc] initWithDic:dic];
}
@end
