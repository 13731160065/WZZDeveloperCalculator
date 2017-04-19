//
//  WZZSingleManager.h
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZSingleManager : NSObject

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 加载js标题
 */
- (NSMutableArray <NSDictionary <NSString *, NSString *>*>*)loadJsTitle;

/**
 保存js代码
 */
- (void)saveJsCode:(NSString *)code title:(NSString *)title;

/**
 加载js代码
 */
- (NSString *)loadJsCodeWithTitle:(NSString *)title;

/**
 删除js代码
 */
- (void)removeJsCodeWithTitle:(NSString *)title;

@end
