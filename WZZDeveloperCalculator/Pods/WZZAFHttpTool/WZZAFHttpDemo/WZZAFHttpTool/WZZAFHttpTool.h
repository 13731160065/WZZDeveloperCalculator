//
//  WZZAFHttpTool.h
//  GoldenMan
//
//  Created by wyq_iMac on 2019/5/7.
//  Copyright © 2019 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@protocol AFMultipartFormData;

@interface WZZAFHttpTool : NSObject

/**
 GET请求
 GET            url地址
 urlParamDic    参数
 successBlock   成功回调
 failedBlock    失败回调
 configBlock    配置（可为空）
 */
+ (NSURLSessionDataTask *)GET:(NSString *)url
                  urlParamDic:(NSDictionary *)urlParamDic
                 successBlock:(void(^)(id httpResponse))successBlock
                  failedBlock:(void(^)(NSError * httpError))failedBlock
                  configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock;

/**
 POST请求
 POST           url地址
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 configBlock    配置（可为空）
 */
+ (NSURLSessionDataTask *)POST:(NSString *)url
                      httpBody:(NSDictionary *)bodyDic
                  successBlock:(void(^)(id httpResponse))successBlock
                   failedBlock:(void(^)(NSError * httpError))failedBlock
                   configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock;

/**
 POST请求带文件
 POST           url地址
 formDataBlock  表单数据
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 configBlock    配置（可为空）
 */
+ (NSURLSessionDataTask *)POST:(NSString *)url
                   addFormData:(void(^)(id<AFMultipartFormData>  _Nonnull formData))formDataBlock
                      httpBody:(NSDictionary *)bodyDic
                  successBlock:(void(^)(id httpResponse))successBlock
                   failedBlock:(void(^)(NSError * httpError))failedBlock
                   configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock;

@end
