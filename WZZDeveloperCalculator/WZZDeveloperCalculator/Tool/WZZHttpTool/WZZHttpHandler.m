//
//  WZZHttpHandler.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/11/15.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZHttpHandler.h"
#import "WZZHttpTool.h"
#import "WZZOCH5Manager.h"

@implementation WZZHttpHandler

//GET请求
+ (void)GET:(NSString *)url
successBlock:(void(^)(id httpResponse))successBlock
failedBlock:(void(^)(NSError * httpError))failedBlock {
    //这里作为中间层，可处理通用逻辑，暂时没用，直接调用网络请求类
    [WZZHttpTool GET:url successBlock:successBlock failedBlock:failedBlock];
}

//获取额外功能列表
+ (void)getExternFunc:(void(^)(NSArray * resp))sb
                   fb:(void(^)(NSError * httpError))fb {
    [self GET:@"https://raw.githubusercontent.com/13731160065/WZZCalH5Project/master/externFunc" successBlock:^(id httpResponse) {
        NSArray * arr = httpResponse;
        if (sb) {
            sb(arr);
        }
    } failedBlock:^(NSError *httpError) {
        if (fb) {
            fb(httpError);
        }
    }];
}

//检测zip包
+ (void)checkZipVersion:(void(^)(NSString * zipVersion))sb
                     fb:(void(^)(NSError * httpError))fb {
    [self GET:@"https://raw.githubusercontent.com/13731160065/WZZCalH5Project/master/zipVersion" successBlock:^(id httpResponse) {
        if (sb) {
            sb(httpResponse);
        }
    } failedBlock:^(NSError *httpError) {
        if (fb) {
            fb(httpError);
        }
    }];
}

//更新zip包
+ (void)updateZip:(void(^)())sb
               fb:(void(^)(NSError * httpError))fb {
    dispatch_queue_t tt = dispatch_queue_create("zipdownload", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(tt, ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/13731160065/WZZCalH5Project/master/homeUrl"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data.length) {
                [WZZOCH5Manager unzipToBundleWithData:data];
                if (sb) {
                    sb();
                }
            } else {
                if (fb) {
                    fb(nil);
                }
            }
        });
    });
}

@end
