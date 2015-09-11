//
//  NSDate+Translate.h
//  Carousel
//
//  Created by Derick Liu on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Translate)
+ (NSDateFormatter *)dateFormatter;
+ (NSDate*)localDateToServerDate:(NSDate*)localDate;
+ (NSDate*)serverDateToLocalDate:(NSDate*)serverDate;
+ (NSDate*)localDate;
+ (NSString *)getTimeNow;
+ (NSDate*)formatterTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)formatterNSdate:(NSDate *)formatDate withFormat:(NSString *)formatter;
+ (NSString *)formatterLongNSdate:(long)formatLongDate withFormat:(NSString *)formatter;
- (NSInteger)differBetweenTwoNSdate:(NSDate *)anotherDate;
- (BOOL)isBetweenFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate;
+ (long long)longlongNowTime;
+ (long long)longlongWithTimeFormatter:(NSString *)timeText;
+ (NSString *)getWeekBeginAndEnd;
+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate;
+ (NSString *)getMonthNow;
+ (NSString *)getYearAndMonthNow;
+ (NSString *)getYearNow;
+ (NSString *)getDayNow;
+ (NSString *)getDetailTimeNow;
+(NSDate *)getLastDateWithCalendarUnit:(NSCalendarUnit)unit withDate:(NSDate *)fromDate;
+ (NSDate *)getFirstDateWithCalendarUnit:(NSCalendarUnit)unit withDate:(NSDate *)fromDate;
+ (BOOL)isSameDayCurrent:(NSDate *)timeDate;
+ (NSString *)getTimeFromTimestamp:(NSString *)time;
@end
