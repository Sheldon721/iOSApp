//
//  XinWenLeiXingModel.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/7.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenLeiXingModel.h"

@implementation XinWenLeiXingModel
//告诉框架数组中存放XinWenModel对象
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list" : @"XinWenModel"
             };
}
@end
