//
//  UIView+WZZAnimation.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/6/26.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "UIView+WZZAnimation.h"

@implementation UIView (WZZAnimation)

#pragma mark - launchPad
- (void)showLikeLaunchPadWithDuration:(NSTimeInterval)duration
                             complete:(void (^)(void))complete {
    self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    self.alpha = 0.0f;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

- (void)dismissLikeLaunchPadDuration:(NSTimeInterval)duration
                            complete:(void (^)(void))complete {
    self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.alpha = 1.0f;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

- (void)moveWithSpeed:(double)speed
            fromPoint:(CGPoint)fromPoint
              toPoint:(CGPoint)toPoint
             complete:(void (^)(void))complete {
    CGFloat xabs = (fromPoint.x > toPoint.x)?(fromPoint.x-toPoint.x):(toPoint.x-fromPoint.x);
    CGFloat yabs = (fromPoint.y > toPoint.y)?(fromPoint.y-toPoint.y):(toPoint.y-fromPoint.y);
    CGFloat s2 = pow(xabs, 2)+pow(yabs, 2);
    CGFloat s = sqrt(s2);
    
    NSTimeInterval time = s/speed;
    [self moveWithDuration:time fromPoint:fromPoint toPoint:toPoint complete:complete];
}

- (void)moveWithDuration:(NSTimeInterval)time
               fromPoint:(CGPoint)fromPoint
                 toPoint:(CGPoint)toPoint
                complete:(void (^)(void))complete {
    CGRect frame = self.frame;
    frame.origin = fromPoint;
    self.frame = frame;
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.frame;
        frame.origin = toPoint;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

@end
