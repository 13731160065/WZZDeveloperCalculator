//
//  UIView+WZZSubviewAction.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/9/7.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "UIView+WZZSubviewAction.h"
#import <objc/runtime.h>

@implementation UIView (WZZSubviewAction)

//MARK:注册监听addsubview事件
+ (void)wzz_registerAddSubviewAction {
    Method m1 = class_getInstanceMethod(self, @selector(addSubview:));
    Method m2 = class_getInstanceMethod(self, @selector(__wzzAddSubview:));
    method_exchangeImplementations(m1, m2);
}

//MARK:添加视图交换方法
- (void)__wzzAddSubview:(UIView *)view {
    [view wzz_willBeAddSubview];
    [self __wzzAddSubview:view];
    [view wzz_didAddSubview];
}

//MARK:将要被加到视图上
- (void)wzz_willBeAddSubview {
    
}

//MARK:已经被加到视图上
- (void)wzz_didAddSubview {
    
}

@end
