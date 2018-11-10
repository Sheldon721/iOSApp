//
//  YFHistoryTools.m
//  PSB2
//
//  Created by李晓东 on 2017/10/26.
//  Copyright © 2017年李晓东. All rights reserved.
//

#import "YFHistoryTools.h"
#define history_location [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"histry.ar"]
@implementation YFHistoryTools
+ (instancetype)shareHistoryTools{
    
    static YFHistoryTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc]init];
    });
    return tools;
}

- (void)saveDataToLocation:(NSString *)str{
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[self obtainDataByLocation]];
    //数据处理
    NSDateFormatter *m = [[NSDateFormatter alloc]init];
    [m setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    str = [NSString stringWithFormat:@"在%@，您进行一次去往%@的导航。",[m stringFromDate:[[NSDate alloc]init]],str];
    [array addObject:str];
    //保存
    [NSKeyedArchiver archiveRootObject:array toFile:history_location];
}

- (NSArray *)obtainDataByLocation{
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:history_location];
    if (![array isKindOfClass:[NSNull class]] && array != nil && array.count > 0) {
        
        return array;
    }
   return [[NSArray alloc]init];
}

- (void)deleteDataByLocation{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:history_location]) {
        
        [manager removeItemAtPath:history_location error:nil];
    }
}
@end
