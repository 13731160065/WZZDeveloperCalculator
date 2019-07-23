//
//  UIView+WZZSubviewAction.h
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/9/7.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WZZSubviewAction)

/**
 注册监听addsubview事件
 当一个视图被addsubview时将会触发
 */
+ (void)wzz_registerAddSubviewAction;

/**
 将要被加到视图上
 在UIView子类中实现该方法即可
 */
- (void)wzz_willBeAddSubview;

/**
 已经被加到视图上
 在UIView子类中实现该方法即可
 */
- (void)wzz_didAddSubview;

@end
