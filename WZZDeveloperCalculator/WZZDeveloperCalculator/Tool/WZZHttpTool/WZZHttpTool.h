//
//  WZZHttpTool.h
//  WZZHttpTool
//
//  Created by 王泽众 on 2017/5/20.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WZZHttpToolBodyType_textPlain = 0,
    WZZHttpToolBodyType_jsonData,
    WZZHttpToolBodyType_default = WZZHttpToolBodyType_textPlain
}WZZHttpToolBodyType;

@interface WZZHttpTool : NSObject

@property (nonatomic, assign) WZZHttpToolBodyType bodyType;

+ (instancetype)shareInstance;

/**
 通用网络请求
 method         请求方式
 url            url地址
 httpHeader     请求头
 httpBody       请求体
 bodyType       请求体格式
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               httpHeader:(NSDictionary *)headerDic
                 httpBody:(NSDictionary *)bodyDic
                 bodyType:(WZZHttpToolBodyType)bodyType
             successBlock:(void(^)(id httpResponse))successBlock
              failedBlock:(void(^)(NSError * httpError))failedBlock;

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
 POST请求
 POST           url地址
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)POST:(NSString *)url
    httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id httpResponse))successBlock
 failedBlock:(void(^)(NSError * httpError))failedBlock;

/**
 PUT请求
 PUT            url地址
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)PUT:(NSString *)url
   httpBody:(NSDictionary *)bodyDic
successBlock:(void(^)(id httpResponse))successBlock
failedBlock:(void(^)(NSError * httpError))failedBlock;

/**
 DELETE请求
 DELETE         url地址
 httpBody       请求体
 successBlock   成功回调
 failedBlock    失败回调
 */
+ (void)DELETE:(NSString *)url
      httpBody:(NSDictionary *)bodyDic
  successBlock:(void(^)(id httpResponse))successBlock
   failedBlock:(void(^)(NSError * httpError))failedBlock;

#pragma mark - 工具
/**
 json转对象
 */
+ (id)jsonToObject:(NSString *)jsonString;

/**
 对象转json字符串
 */
+ (NSString *)objectToJson:(id)object;

@end
