//
//  UIView+WZZAnimation.h
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/6/26.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WZZAnimation)

#pragma mark - launchPad
/**
 像MAC的LaunchPad一样出现

 @param complete 动画结束
 */
- (void)showLikeLaunchPadWithDuration:(NSTimeInterval)duration
                             complete:(void(^)(void))complete;

/**
 像MAC的LaunchPad一样消失
 
 @param complete 动画结束
 */
- (void)dismissLikeLaunchPadDuration:(NSTimeInterval)duration
                            complete:(void(^)(void))complete;

#pragma mark - 移动

/**
 移动

 @param speed 速度
 @param fromPoint 从哪
 @param toPoint 到哪
 @param complete 结束
 */
- (void)moveWithSpeed:(double)speed
            fromPoint:(CGPoint)fromPoint
              toPoint:(CGPoint)toPoint
             complete:(void (^)(void))complete;

/**
 移动

 @param time 时间
 @param fromPoint 从哪
 @param toPoint 到哪
 @param complete 结束
 */
- (void)moveWithDuration:(NSTimeInterval)time
               fromPoint:(CGPoint)fromPoint
                 toPoint:(CGPoint)toPoint
                complete:(void (^)(void))complete;


@end
