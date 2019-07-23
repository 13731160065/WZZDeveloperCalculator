//
//  WZZAFHttpTool.m
//  GoldenMan
//
//  Created by wyq_iMac on 2019/5/7.
//  Copyright © 2019 王泽众. All rights reserved.
//

#import "WZZAFHttpTool.h"
#import "AFNetworking.h"

@implementation WZZAFHttpTool

//get请求
+ (NSURLSessionDataTask *)GET:(NSString *)url
                  urlParamDic:(NSDictionary *)urlParamDic
                 successBlock:(void (^)(id))successBlock
                  failedBlock:(void (^)(NSError *))failedBlock
                  configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json", @"text/plain"]];
    if (configBlock) {
        configBlock(manager);
    }
    NSURLSessionDataTask * task = [manager GET:url parameters:urlParamDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    return task;
}

//post请求
+ (NSURLSessionDataTask *)POST:(NSString *)url
                      httpBody:(NSDictionary *)bodyDic
                  successBlock:(void (^)(id))successBlock
                   failedBlock:(void (^)(NSError *))failedBlock
                   configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json", @"text/plain"]];
    if (configBlock) {
        configBlock(manager);
    }
    NSURLSessionDataTask * task = [manager POST:url parameters:bodyDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    return task;
}

//上传文件post请求
+ (NSURLSessionDataTask *)POST:(NSString *)url
                   addFormData:(void (^)(id<AFMultipartFormData>  _Nonnull formData))formDataBlock
                      httpBody:(NSDictionary *)bodyDic successBlock:(void (^)(id))successBlock
                   failedBlock:(void (^)(NSError *))failedBlock
                   configBlock:(void(^)(AFHTTPSessionManager * manager))configBlock {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json", @"text/plain"]];
    if (configBlock) {
        configBlock(manager);
    }
    NSURLSessionDataTask * task = [manager POST:url parameters:bodyDic constructingBodyWithBlock:formDataBlock progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    return task;
}


@end
