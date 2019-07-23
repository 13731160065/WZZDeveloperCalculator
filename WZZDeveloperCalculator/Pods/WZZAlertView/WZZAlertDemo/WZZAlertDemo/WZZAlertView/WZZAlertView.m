//
//  WZZAlertView.m
//  DuoDuoFu
//
//  Created by 王泽众 on 2018/3/24.
//  Copyright © 2018年 hongfuPay. All rights reserved.
//

#import "WZZAlertView.h"

#define BORDERCOLOR [UIColor lightGrayColor]

@interface WZZAlertView () {
    UIView * updateView;
    UIView * alertV;
    NSLayoutConstraint * alertConCenterY;
    NSArray <WZZAlertAction *>* actionsArr;
    NSArray <WZZAlertTextField *>* tfsArr;
    NSString * thisTitle;
    NSString * thisDetail;
    CAShapeLayer * fillLayer;
}

@end

@implementation WZZAlertView

//获取实例
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail {
    return [self alertWithTitle:title detail:detail actions:[NSArray array]];
}

//获取实例带动作
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail
                       actions:(NSArray <WZZAlertAction *>*)actions {
    return [self alertWithTitle:title detail:detail actions:actions textFields:[NSArray array]];
}

//获取实例带tf
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail
                       actions:(NSArray<WZZAlertAction *> *)actions
                    textFields:(NSArray<WZZAlertTextField *> *)textFields {
    WZZAlertView * alert = [[WZZAlertView alloc] initWithFrame:CGRectZero];
    alert->thisTitle = title;
    alert->thisDetail = detail;
    alert->actionsArr = actions;
    alert->tfsArr = textFields;
    
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(keyShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(keyHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return alert;
}

//添加动作
- (void)addAction:(WZZAlertAction *)action {
    NSMutableArray * arr = [NSMutableArray arrayWithArray:actionsArr];
    [arr addObject:action];
    actionsArr = arr;
}

//添加tf
- (void)addTextField:(WZZAlertTextField *)tf {
    NSMutableArray * arr = [NSMutableArray arrayWithArray:tfsArr];
    [arr addObject:tf];
    tfsArr = arr;
}

/**
 弹出提示
 */
- (void)show {
    [self setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    updateView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:updateView];
    
    //弹框
    alertV = [[UIView alloc] init];
    alertV.translatesAutoresizingMaskIntoConstraints = NO;
    [updateView addSubview:alertV];
    [alertV.layer setCornerRadius:10.0f];
    [alertV.layer setMasksToBounds:YES];
    [alertV setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    
    
    //layer
    fillLayer = [CAShapeLayer layer];
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5f;
    [updateView.layer addSublayer:fillLayer];
    //动画
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(0.0f);
    anim.toValue = @(0.5f);
    anim.duration = 0.2f;
    [fillLayer addAnimation:anim forKey:@"alphy1"];
    
    UIView * lastView = nil;
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    [alertV addSubview:titleLabel];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:thisTitle];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    //约束
    [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeTop multiplier:1.0f constant:20].active = YES;
    [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:20].active = YES;
    [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20].active = YES;
    
    UIFont * font = [UIFont systemFontOfSize:14];
    //文字
    UILabel * messageLabel = [[UILabel alloc] init];
    [alertV addSubview:messageLabel];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setText:thisDetail];
    [messageLabel setFont:font];
    [messageLabel setNumberOfLines:0];
    //约束
    [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:8.0f].active = YES;
    [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:20].active = YES;
    [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20].active = YES;
    
    lastView = messageLabel;
    
    for (int i = 0; i < tfsArr.count; i++) {
        UIView * tmpTfView = [[UIView alloc] init];
        [alertV addSubview:tmpTfView];
        UITextField * tmpTf = [[UITextField alloc] init];
        [tmpTfView addSubview:tmpTf];
        tmpTf.layer.borderColor = BORDERCOLOR.CGColor;
        tmpTf.layer.borderWidth = 0.7f;
        if (tfsArr[i].alertTFConfig) {
            tfsArr[i].alertTFConfig(tmpTf);
        }
        tmpTfView.layer.borderColor = tmpTf.layer.borderColor;
        tmpTfView.layer.borderWidth = tmpTf.layer.borderWidth;
        tmpTf.layer.borderColor = [UIColor clearColor].CGColor;
        tmpTf.layer.borderWidth = 0;
        
        tmpTf.translatesAutoresizingMaskIntoConstraints = NO;
        tmpTfView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint constraintWithItem:tmpTfView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:i?-0.7f:15].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTfView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:15].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTfView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-15].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTfView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30].active = YES;
        lastView = tmpTfView;
        
        [NSLayoutConstraint constraintWithItem:tmpTf attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tmpTfView attribute:NSLayoutAttributeTop multiplier:1 constant:4].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTf attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tmpTfView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-4].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTf attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tmpTfView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:4].active = YES;
        [NSLayoutConstraint constraintWithItem:tmpTf attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tmpTfView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-4].active = YES;
    }
    
    UIFont * buttonFont = [UIFont systemFontOfSize:17];
    switch (actionsArr.count) {
        case 0:
        {
            //横线
            UIView * line1 = [[UIView alloc] init];
            [alertV addSubview:line1];
            [line1 setBackgroundColor:BORDERCOLOR];
            line1.translatesAutoresizingMaskIntoConstraints = NO;
            //约束
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:15].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.7f].active = YES;
            
            //取消
            UIButton * okButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [alertV addSubview:okButton];
            okButton.translatesAutoresizingMaskIntoConstraints = NO;
            [okButton.titleLabel setFont:buttonFont];
            [okButton setTitle:@"取消" forState:UIControlStateNormal];
            [okButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventAllEvents];
            
            //约束
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:8.0f].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-8.0f].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40].active = YES;
            lastView = okButton;
        }
            break;
        case 2:
        {
            //横排2
            UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
            cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
            [alertV addSubview:cancelButton];
            
            UIButton * okButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [alertV addSubview:okButton];
            okButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            UIView * line1 = [[UIView alloc] init];
            [alertV addSubview:line1];
            line1.translatesAutoresizingMaskIntoConstraints = NO;
            
            UIView * line2 = [[UIView alloc] init];
            [alertV addSubview:line2];
            line2.translatesAutoresizingMaskIntoConstraints = NO;
            
            WZZAlertAction * action = actionsArr[0];
            [cancelButton.titleLabel setFont:buttonFont];
            [cancelButton setTitle:action.title forState:UIControlStateNormal];
            action.button = cancelButton;
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (action.titleColor) {
                [cancelButton setTitleColor:action.titleColor forState:UIControlStateNormal];
            }
            
            WZZAlertAction * action2 = actionsArr[1];
            [okButton.titleLabel setFont:buttonFont];
            [okButton setTitle:action2.title forState:UIControlStateNormal];
            action2.button = okButton;
            [okButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (action2.titleColor) {
                [okButton setTitleColor:action2.titleColor forState:UIControlStateNormal];
            }
            
            //横线
            [line1 setBackgroundColor:BORDERCOLOR];
            //竖线
            [line2 setBackgroundColor:BORDERCOLOR];
            
            //横线约束，l1上等于m下，l1左等于左，l1右等于右，l1高等于0.7
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:15].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.7f].active = YES;
            
            //竖线约束，l2上等于l1下，l2x等于x，l2宽等于0.7，l2高等于40
            [NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.7f].active = YES;
            [NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40].active = YES;

            //b1约束，b1上等于l1下，b1左等于左，b1右等于l2左，b1高等于l2高
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:8.0f].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:line2 attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:okButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:line2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
            
            //b2约束
            [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:line2 attribute:NSLayoutAttributeRight multiplier:1.0f constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-8.0f].active = YES;
            [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:line2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
            
            lastView = line2;
        }
            break;
            
        default:
        {
            //纵排
            for (int i = 0; i < actionsArr.count; i++) {
                //横线
                UIView * line1 = [[UIView alloc] init];
                [alertV addSubview:line1];
                line1.translatesAutoresizingMaskIntoConstraints = NO;
                [line1 setBackgroundColor:BORDERCOLOR];
                
                //横线约束
                [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:i?0:15].active = YES;
                [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.7f].active = YES;
                
                WZZAlertAction * action = actionsArr[i];
                UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
                [alertV addSubview:cancelButton];
                cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
                [cancelButton.titleLabel setFont:buttonFont];
                [cancelButton setTitle:action.title forState:UIControlStateNormal];
                [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                if (action.titleColor) {
                    [cancelButton setTitleColor:action.titleColor forState:UIControlStateNormal];
                }
                action.button = cancelButton;
                
                //约束
                [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeLeft multiplier:1.0f constant:8.0f].active = YES;
                [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertV attribute:NSLayoutAttributeRight multiplier:1.0f constant:-8.0f].active = YES;
                [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40].active = YES;
                
                lastView = cancelButton;
            }
        }
            break;
    }
    
    //弹框约束
    [NSLayoutConstraint constraintWithItem:alertV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:280].active = YES;
    [NSLayoutConstraint constraintWithItem:alertV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:alertV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:updateView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = YES;
    alertConCenterY = [NSLayoutConstraint constraintWithItem:alertV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:updateView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    alertConCenterY.active = YES;
    
    [self layoutIfNeeded];
    
    /*
     毛玻璃
     */
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = alertV.bounds;
    [alertV insertSubview:effectView atIndex:0];
    
    
    //镂空背景
    CGRect myRect = alertV.frame;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:updateView.bounds cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:10];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    fillLayer.path = path.CGPath;
    
    [alertV setAlpha:0.0f];
    CGAffineTransform tr = updateView.transform;
    updateView.transform = CGAffineTransformScale(updateView.transform, 1.1f, 1.1f);
    
    __weak UIView * alertVw = alertV;
    __weak UIView * updateVieww = updateView;
    [UIView animateWithDuration:0.2f animations:^{
        [alertVw setAlpha:1.0f];
        updateVieww.transform = tr;
    }];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancelClick];
}

- (void)cancelClick {
    fillLayer.opacity = 0.0f;
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(0.5f);
    anim.toValue = @(0.0f);
    anim.duration = 0.2f;
    [anim setRemovedOnCompletion:NO];
    [fillLayer addAnimation:anim forKey:@"alphy2"];
    
    //取消
    __weak UIView * alertVw = alertV;
    __weak UIView * weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        [alertVw setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)buttonClick:(UIButton *)button {
    [actionsArr enumerateObjectsUsingBlock:^(WZZAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.button == button) {
            if (obj.actionBlock) {
                obj.actionBlock(self);
            }
        }
    }];
}

- (void)keyShow:(NSNotification *)noti {
    NSDictionary * obj = noti.userInfo;
    CGRect re = [obj[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat hei = [UIScreen mainScreen].bounds.size.height/2.0f-re.origin.y/2.0f;
    alertConCenterY.constant = -hei;
    [self layoutIfNeeded];

    //镂空背景
    CGRect myRect = alertV.frame;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:updateView.bounds cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:10];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    fillLayer.path = path.CGPath;
}

- (void)keyHide:(NSNotification *)noti {
    alertConCenterY.constant = 0;
    [self layoutIfNeeded];
    
    //镂空背景
    CGRect myRect = alertV.frame;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:updateView.bounds cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:10];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    fillLayer.path = path.CGPath;
}

@end

@implementation WZZAlertAction

+ (WZZAlertAction *)actionWithTitle:(NSString *)title
                             action:(void (^)(WZZAlertView *))actionBlock {
    WZZAlertAction * action = [[WZZAlertAction alloc] init];
    action.title = title;
    action.actionBlock = actionBlock;
    return action;
}

@end

@implementation WZZAlertTextField

+ (instancetype)textFieldWithConfig:(void (^)(UITextField *))tfConfig {
    WZZAlertTextField * tf = [[WZZAlertTextField alloc] init];
    tf.alertTFConfig = tfConfig;
    return tf;
}

@end
