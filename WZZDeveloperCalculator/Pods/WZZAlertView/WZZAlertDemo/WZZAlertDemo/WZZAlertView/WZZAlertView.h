//
//  WZZAlertView.h
//  DuoDuoFu
//
//  Created by 王泽众 on 2018/3/24.
//  Copyright © 2018年 hongfuPay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZZAlertAction;
@class WZZAlertTextField;

@interface WZZAlertView : UIView

/**
 弹出框

 @param title 标题
 @param detail 详情
 @return 实例
 */
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail;

/**
 弹出框
 
 @param title 标题
 @param detail 详情
 @param actions 点击数组
 @return 实例
 */
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail
                       actions:(NSArray <WZZAlertAction *>*)actions;

/**
 弹出框

 @param title 标题
 @param detail 详情
 @param actions 点击数组
 @param textFields 输入框数组
 @return 实例
 */
+ (instancetype)alertWithTitle:(NSString *)title
                        detail:(NSString *)detail
                       actions:(NSArray <WZZAlertAction *>*)actions
                    textFields:(NSArray <WZZAlertTextField *>*)textFields;

/**
 添加动作

 @param action 动作
 */
- (void)addAction:(WZZAlertAction *)action;

/**
 添加输入框

 @param tf 输入框
 */
- (void)addTextField:(WZZAlertTextField *)tf;

/**
 显示
 */
- (void)show;

/**
 消失
 */
- (void)dismiss;

@end

@interface WZZAlertAction : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) void(^actionBlock)(WZZAlertView *);
@property (nonatomic, strong) UIButton * button;

/**
 动作
 
 @param title 标题
 @param actionBlock 回调
 @return action
 */
+ (WZZAlertAction *)actionWithTitle:(NSString *)title
                             action:(void(^)(WZZAlertView * aAlertView))actionBlock;

@end

@interface WZZAlertTextField : NSObject

/**
 配置tf的block，不需要调用
 */
@property (nonatomic, strong) void(^alertTFConfig)(UITextField * alertTF);

/**
 生成实例

 @param tfConfig 配置tf
 */
+ (instancetype)textFieldWithConfig:(void(^)(UITextField * alertTF))tfConfig;

@end
