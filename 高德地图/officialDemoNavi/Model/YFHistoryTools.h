//
//  YFHistoryTools.h
//  PSB2
//
//  Created by李晓东 on 2017/10/26.
//  Copyright © 2017年李晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHistoryTools : NSObject
+ (instancetype)shareHistoryTools;
- (void)saveDataToLocation:(NSString *)str;
- (NSArray *)obtainDataByLocation;
- (void)deleteDataByLocation;

@end
