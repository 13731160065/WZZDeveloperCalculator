//
//  WZZCalModel.h
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZCalModel : NSObject

/**
 10进制键盘
 */
@property (strong, nonatomic, readonly) NSMutableArray * calPad10;

/**
 2进制键盘
 */
@property (strong, nonatomic, readonly) NSMutableArray * calPad2;

/**
 8进制键盘
 */
@property (strong, nonatomic, readonly) NSMutableArray * calPad8;

/**
 16进制键盘
 */
@property (strong, nonatomic, readonly) NSMutableArray * calPad16;

/**
 当前键盘
 */
@property (strong, nonatomic, readonly) NSMutableArray * currentCalPad;

/**
 键盘数组
 */
@property (strong, nonatomic, readonly) NSMutableArray * padsArr;

/**
 当前数
 */
@property (strong, nonatomic) NSString * currentNum;

/**
 操作数1
 */
@property (nonatomic, strong) NSString * d1;

/**
 操作符
 */
@property (nonatomic, strong) NSString * op;

/**
 操作数2
 */
@property (nonatomic, strong) NSString * d2;

/**
 获取实例
 */
+ (instancetype)shareInstance;

/**
 处理文字
 */
- (NSString *)handleText:(NSString *)text;

@end
