//
//  DateUtil.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format;
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)dateIdentifierNow;
+ (NSString*)dateString:(NSString*)originalStr fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat;
+ (NSString*)appendWeekStringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
