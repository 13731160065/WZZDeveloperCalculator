//
//  WZZHttpHandler.h
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/11/15.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZHttpHandler : NSObject

/**
 GET请求
 GET            url地址
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)GET:(NSString *)url
successBlock:(void(^)(id httpResponse))successBlock
failedBlock:(void(^)(NSError * httpError))failedBlock;

/**
 获取额外功能列表
 sb 成功回调
 fb 失败回调
 */
+ (void)getExternFunc:(void(^)(NSArray * resp))sb
                   fb:(void(^)(NSError * httpError))fb;

/**
 检测zip包
 sb 成功回调
 fb 失败回调
 */
+ (void)checkZipVersion:(void(^)(NSString * zipVersion))sb
                     fb:(void(^)(NSError * httpError))fb;

/**
 更新zip包
 sb 成功回调
 fb 失败回调
 */
+ (void)updateZip:(void(^)())sb
               fb:(void(^)(NSError * httpError))fb;

@end
