//
//  WZZSingleManager.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZSingleManager.h"

#define JSCODEKEY @"jscodetitle"

static WZZSingleManager * mm;

@implementation WZZSingleManager

//单例
+ (instancetype)shareInstance {
    if (!mm) {
        mm = [[WZZSingleManager alloc] init];
    }
    return mm;
}

//加载js标题
- (NSMutableArray <NSDictionary <NSString *, NSString *>*>*)loadJsTitle {
    NSString * jsTitle = [[NSUserDefaults standardUserDefaults] objectForKey:JSCODEKEY];
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[jsTitle componentsSeparatedByString:@","]];
    for (int i = 0; i < arr.count; i++) {
        NSString * str = arr[i];
        arr[i] = [[str componentsSeparatedByString:@"js@"] componentsJoinedByString:@""];
    }
    return arr;
}

//保存js代码
- (void)saveJsCode:(NSString *)code title:(NSString *)title {
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:[NSString stringWithFormat:@"js@%@", title]];
}

//加载js代码
- (NSString *)loadJsCodeWithTitle:(NSString *)title {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"js@%@", title]];
}

@end
