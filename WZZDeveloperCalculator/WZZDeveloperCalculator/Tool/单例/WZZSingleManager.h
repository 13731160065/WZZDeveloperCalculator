//
//  WZZSingleManager.h
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

struct WZZMAXMINNUM {
    NSInteger max;
    NSInteger min;
};

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

/**
 获取最大最小值
 */
- (struct WZZMAXMINNUM)loadMaxMinNum;

/**
 保存最大最小值
 */
- (void)saveMaxMinNum:(struct WZZMAXMINNUM)maxMinNum;

/**
 展示引导图
 */
- (void)showGuide;

/**
 注册tip
 */
- (void)registerIsNewVersionWithType:(NSString *)type;

/**
 检测tip
 */
- (BOOL)checkIsNewVersionWithType:(NSString *)type;

@end
