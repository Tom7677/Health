//
//  NSDate+Translate.m
//  Carousel
//
//  Created by Derick Liu on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Translate.h"

@implementation NSDate (Translate)
#pragma mark-
+ (NSDateFormatter *)dateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

+ (NSDate *)localDateToServerDate:(NSDate *)localDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:localDate];
    NSDate *serverDate = [localDate  dateByAddingTimeInterval: -interval]; 
    return serverDate;
}

+ (NSDate *)serverDateToLocalDate:(NSDate *)serverDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:serverDate];
    NSDate *localeDate = [serverDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate *)localDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    NSLog(@"%@", timeNow);
    return timeNow;
}

+ (NSDate *)formatterTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [NSDate dateWithTimeIntervalSince1970: timeInterval];
}

+ (NSString *)formatterNSdate:(NSDate *)formatDate withFormat:(NSString *)formatter
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:formatDate];
}

+ (NSString *)formatterLongNSdate:(long)formatLongDate withFormat:(NSString *)formatter
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:[self dateWithTimeIntervalSince1970:formatLongDate]];
}

- (NSInteger)differBetweenTwoNSdate:(NSDate *)anotherDate
{
    NSTimeInterval lastDiff = [anotherDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [self timeIntervalSinceNow];
    NSTimeInterval dateDiff = lastDiff - todaysDiff;
    return dateDiff/60/60/24 + 1;
}

+ (BOOL)isSameDayCurrent:(NSDate *)timeDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateSMS = [dateFormatter stringFromDate:timeDate];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isBetweenFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate
{
    BOOL between = NO;
    if (([self compare:startDate] == NSOrderedDescending) &&
        ([self compare:endDate] == NSOrderedAscending)) {
        between = YES;
    }else if([self compare:startDate] == NSOrderedSame){
        between = YES;
    }else if([self compare:endDate] == NSOrderedSame){
        between = YES;
    }
    return between;
}

+ (long long)longlongNowTime
{
    return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (long long)longlongWithTimeFormatter:(NSString *)timeText
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy:MM:DD HH:mm:ss"];
    NSDate *date = [dateFormater dateFromString:timeText];
    return (long long)[date timeIntervalSince1970];
}

+ (NSString *)getWeekBeginAndEnd
{
    NSString *resultStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *date=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    NSDateComponents *comps=[calendar components:(NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit) fromDate:date];
    NSInteger weekday=[comps weekday];//注意  周日 是 “1”，周一是 “2”
    NSInteger theWeekDay=weekday-1;
    NSDate *nowDate=[[NSDate alloc] init];
    if (theWeekDay==0) {//今天是星期天
        NSTimeInterval interval=24*60*60*6;//减6天
        NSDate *benginDate=[nowDate initWithTimeIntervalSinceNow:-interval];
        NSString *beginDateStr=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:benginDate]];
        NSString *endDateStr=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        resultStr=[NSString stringWithFormat:@"%@ - %@",beginDateStr,endDateStr];
    }
    else{
        NSTimeInterval benginInterval=-(theWeekDay-1)*24*60*60;//向前 减的毫秒数
        NSTimeInterval endInterval=+(7-theWeekDay)*24*60*60;//向后 加的毫秒数
        NSDate *beginDate=[nowDate initWithTimeIntervalSinceNow:benginInterval];
        NSDate *endDate=[nowDate initWithTimeIntervalSinceNow:endInterval];
        NSString *beginDateStr=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:beginDate]];
        NSString *endDateStr=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:endDate]];
        resultStr=[NSString stringWithFormat:@"%@ - %@",beginDateStr,endDateStr];
    }
    return resultStr;
}

+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate
{
     NSString *resultStr;
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        resultStr=[NSString stringWithFormat:@"%@ - %@",newDate,newDate];
        return resultStr;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM月dd日"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    resultStr=[NSString stringWithFormat:@"%@ - %@",beginString,endString];
    return  resultStr;
}

+(NSDate *)getLastDateWithCalendarUnit:(NSCalendarUnit)unit withDate:(NSDate *)fromDate
{
    if (fromDate == nil) {
        fromDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:unit startDate:&beginDate interval:&interval forDate:fromDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    return endDate;
}

+ (NSDate *)getFirstDateWithCalendarUnit:(NSCalendarUnit)unit withDate:(NSDate *)fromDate
{
    NSDate *beginOfMonth = nil;
    NSTimeInterval endDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    BOOL success = [calendar rangeOfUnit:unit startDate:&beginOfMonth interval:&endDate forDate:fromDate];
    if (success){
        return beginOfMonth;
    }else{
        return nil;
    }
}

+ (NSString *)getMonthNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"M月"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getYearNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY年"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getDayNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"dd"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getDetailTimeNow
{
    NSString *date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy月MM月dd日 HH:mm"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getTimeFromTimestamp:(NSString *)time
{
    NSTimeInterval timeInterval = [time longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *newTime = [dateFormatter stringFromDate:date];
    return newTime;
}

+ (NSString *)getYearAndMonthNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY/M"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}
@end
