//
//  DateUtil.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString* dateToString = [dateFormatter stringFromDate:date];
    return dateToString;
}
+ (NSString*)dateString:(NSString*)originalStr fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = fromFormat;
    NSDate* date = [dateFormatter dateFromString:originalStr];
    dateFormatter.dateFormat = toFormat;
    return [dateFormatter stringFromDate:date];
}
+ (NSString*)dateIdentifierNow
{
    return [self dateString:[NSDate date] withFormat:@"yyyyMMddHHmmssfff"];
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray* weekdays = [NSArray arrayWithObjects:[NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];

    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSTimeZone* timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    [calendar setTimeZone:timeZone];

    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;

    NSDateComponents* theComponents = [calendar components:calendarUnit fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString*)appendWeekStringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    return [NSString stringWithFormat:@"%@ %@", [self dateString:date withFormat:format], [self weekdayStringFromDate:date]];
}
@end
