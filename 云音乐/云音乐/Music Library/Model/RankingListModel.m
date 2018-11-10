//
//  RankingListModel.m
//  云音乐
//
//  Created by 李晓东 on 2017/9/23.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "RankingListModel.h"

@implementation RankingListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"hashId":@"hash"
             
             };
}
@end
