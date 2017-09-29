//
//  WZZSelectView.h
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/10.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZSelectView : UIButton

/**
 显示，默认数据源
 */
+ (void)showWithRect:(CGRect)rect selectBlock:(void (^)(NSString * selectStr))aBlock;

/**
 显示，带数据源
 */
+ (void)showWithRect:(CGRect)rect dataArr:(NSArray *)dataArr selectBlock:(void (^)(NSString *))aBlock;

@end
