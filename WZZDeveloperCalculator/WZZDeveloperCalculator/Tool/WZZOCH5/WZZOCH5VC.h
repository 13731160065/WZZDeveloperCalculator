//
//  WZZOCH5VC.h
//  WZZOCH5Demo
//
//  Created by 王泽众 on 2017/9/26.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WZZOCH5Delegate <JSExport>

#pragma mark - 类与变量
//创建类
- (id)allocWithClass:(NSString *)className;

//调用方法
- (id)runFuncWithObj:(id)obj FuncName:(NSString *)funcName;
- (id)runFuncWithObj:(id)obj FuncName:(NSString *)funcName Arg1:(id)arg1;
- (id)runFuncWithObj:(id)obj FuncName:(NSString *)funcName Arg1:(id)arg1 Arg2:(id)arg2;

//获取变量
- (id)getObjWithKeyPath:(NSString *)keyPath Obj:(id)obj;

//变量赋值
- (void)setObjWithKeyPath:(NSString *)keyPath Value:(id)value Obj:(id)obj;

//刷新页面
- (void)reloadWithUrl:(NSString *)str;

#pragma mark - 界面跳转
//nav模式进入界面
- (void)pushVC:(id)vc;

//nav模式退出界面
- (void)popVC;

//present模式进入界面
- (void)presentVC:(id)vc;

//present模式退出界面
- (void)dismissVC;

#pragma mark - 回调函数
//js回调oc接口，可以返回json字符串给oc，视情况而定
- (void)returnJsonStr:(id)jsonStr;

@end

@interface WZZOCH5VC : UIViewController<WZZOCH5Delegate>

/**
 加载的url
 */
@property (nonatomic, strong) NSString * url;

/**
 原生参数
 原生参数在js中以och5_xxx的形式调用
 */
@property (nonatomic, strong) NSDictionary <NSString *, id>* args;

/**
 处理js回调
 */
- (void)handleJSCallBack:(void(^)(id resp))aBlock;

@end
