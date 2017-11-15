//
//  WZZOCH5Manager.h
//  WZZOCH5Demo
//
//  Created by 王泽众 on 2017/9/26.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZOCH5Manager : NSObject

/**
 www根目录，不带/
 */
+ (NSString *)wwwDir;

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 检测包版本
 */
+ (NSString *)getVersion;

/**
 解压数据
 */
+ (void)unzipToBundleWithData:(NSData *)data;

@end
