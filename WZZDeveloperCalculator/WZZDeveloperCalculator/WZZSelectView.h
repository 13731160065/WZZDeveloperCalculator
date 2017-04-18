//
//  WZZSelectView.h
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/10.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZSelectView : UIButton

/**
 显示
 */
+ (void)showWithRect:(CGRect)rect selectBlock:(void (^)(NSString * selectStr))aBlock;

@end
