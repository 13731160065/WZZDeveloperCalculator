//
//  WZZTimeHandler.m
//  周小七
//
//  Created by 王泽众 on 2017/5/18.
//  Copyright © 2017年 LST. All rights reserved.
//

#import "WZZTimeHandler.h"

@implementation WZZTimeHandler

//创建当前时间
+ (instancetype)now {
    return [self handleWithDate:[NSDate date]];
}

//根据时间创建时间
+ (instancetype)handleWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //年
    [formatter setDateFormat:@"yyyy"];
    NSString *yearStr = [formatter stringFromDate:date];
    
    //月
    [formatter setDateFormat:@"MM"];
    NSString * monthStr = [formatter stringFromDate:date];
    
    //日
    [formatter setDateFormat:@"dd"];
    NSString * dayStr = [formatter stringFromDate:date];
    
    //时
    [formatter setDateFormat:@"HH"];
    NSString *hourStr = [formatter stringFromDate:date];
    
    //分
    [formatter setDateFormat:@"mm"];
    NSString * minStr = [formatter stringFromDate:date];
    
    //秒
    [formatter setDateFormat:@"ss"];
    NSString * secStr = [formatter stringFromDate:date];
    
    WZZTimeHandler * handle = [[WZZTimeHandler alloc] init];
    handle.date = date;
    handle.year = yearStr.intValue;
    handle.month = monthStr.intValue;
    handle.day = dayStr.intValue;
    handle.hour = hourStr.intValue;
    handle.min = minStr.intValue;
    handle.sec = secStr.intValue;
    handle.timeTemp = (int)[date timeIntervalSince1970];
    
    return handle;
}

+ (instancetype)timeWithDate:(NSDate *)date {
    return [self handleWithDate:date];
}

//根据时间戳创建时间
+ (instancetype)timeWithTimeTemp:(NSInteger)timeTemp {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeTemp];
    return [self handleWithDate:date];
}

+ (instancetype)timeWithTimeStr:(NSString *)timeStr {
    if (timeStr.length == 16) {
        timeStr = [timeStr stringByAppendingString:@":00"];
    }
    if (timeStr.length != 19) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return [self handleWithDate:date];
}

//加一小时
- (void)addOneHour {
    _hour++;
    if (_hour > 23) {
        _hour = 0;
    }
}

//减一小时
- (void)subOneHour {
    _hour--;
    if (_hour < 0) {
        _hour = 23;
    }
}

//加十分
- (void)add10Min {
    _min+=10;
    if (_min > 59) {
        _min = 0;
    }
}

//减十分
- (void)sub10Min {
    _min-=10;
    if (_min < 0) {
        _min = 59;
    }
}

//加一天
- (void)addOneDay {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.timeTemp];
    date = [date dateByAddingTimeInterval:3600*24];
    int timeTemp = (int)[date timeIntervalSince1970];
    WZZTimeHandler * time = [WZZTimeHandler timeWithTimeTemp:timeTemp];
    self.year = time.year;
    self.month = time.month;
    self.day = time.day;
    self.hour = time.hour;
    self.min = time.min;
    self.sec = time.sec;
    self.timeTemp = time.timeTemp;
}

//减一天
- (void)subOneDay {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.timeTemp];
    date = [date dateByAddingTimeInterval:-3600*24];
    int timeTemp = (int)[date timeIntervalSince1970];
    WZZTimeHandler * time = [WZZTimeHandler timeWithTimeTemp:timeTemp];
    self.year = time.year;
    self.month = time.month;
    self.day = time.day;
    self.hour = time.hour;
    self.min = time.min;
    self.sec = time.sec;
    self.timeTemp = time.timeTemp;
}

@end
