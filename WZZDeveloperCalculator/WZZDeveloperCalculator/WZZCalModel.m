//
//  WZZCalModel.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZCalModel.h"

static WZZCalModel * model;

@implementation WZZCalModel

+ (instancetype)shareInstance {
    if (!model) {
        model = [[WZZCalModel alloc] init];
    }
    return model;
}

- (NSMutableArray *)calPad10 {
    NSMutableArray * arr = [NSMutableArray array];
    
    _currentCalPad = arr;
    return arr;
}

- (NSMutableArray *)calPad2 {
    NSMutableArray * arr = [NSMutableArray array];
    
    _currentCalPad = arr;
    return arr;
}

- (NSMutableArray *)calPad8 {
    NSMutableArray * arr = [NSMutableArray array];
    
    _currentCalPad = arr;
    return arr;
}

- (NSMutableArray *)calPad16 {
    NSMutableArray * arr = [NSMutableArray array];
    
    _currentCalPad = arr;
    return arr;
}

- (NSString *)handleText:(NSString *)text {
    if (self.currentCalPad == self.calPad10) {
        
    } else if (self.currentCalPad == self.calPad2) {
        
    } else if (self.currentCalPad == self.calPad8) {
        
    } else if (self.currentCalPad == self.calPad16) {
        
    }
}

@end
