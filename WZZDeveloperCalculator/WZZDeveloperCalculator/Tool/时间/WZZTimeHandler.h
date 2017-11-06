//
//  WZZTimeHandler.h
//  周小七
//
//  Created by 王泽众 on 2017/5/18.
//  Copyright © 2017年 LST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZTimeHandler : NSObject

@property (nonatomic, assign) int year;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int day;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int min;
@property (nonatomic, assign) int sec;
@property (nonatomic, assign) NSInteger timeTemp;
@property (nonatomic, strong) NSDate * date;

/**
 获取当前时间
 */
+ (instancetype)now;

/**
 根据NSDate获取时间
 */
+ (instancetype)timeWithDate:(NSDate *)date;

/**
 根据时间戳获取时间
 */
+ (instancetype)timeWithTimeTemp:(NSInteger)timeTemp;

/**
 格式化字符串转时间 xxxx-xx-xx xx:xx:xx
 */
+ (instancetype)timeWithTimeStr:(NSString *)timeStr;

/**
 时增加
 */
- (void)addOneHour;

/**
 时减少
 */
- (void)subOneHour;

/**
 上10分钟
 */
- (void)add10Min;

/**
 下10分钟
 */
- (void)sub10Min;

/**
 加一天
 */
- (void)addOneDay;

/**
 减一天
 */
- (void)subOneDay;

@end
