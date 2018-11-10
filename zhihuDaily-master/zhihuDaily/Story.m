//
//  Story.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "Story.h"

@implementation Story
- (instancetype)initWithDic:(NSDictionary*)dic
{
  self = [super init];
  if (self) {
    self.css = [dic[@"css"] firstObject];
    self.image = dic[@"image"];
    self.imageSource = dic[@"image_source"];
    self.body = dic[@"body"];
    self.title = dic[@"title"];
    self.type = [dic[@"type"] integerValue];
    self.id = [dic[@"id"] integerValue];
  }
  return self;
}

+ (instancetype)storyWithDic:(NSDictionary*)dic
{
  return [[self alloc] initWithDic:dic];
}

@end
