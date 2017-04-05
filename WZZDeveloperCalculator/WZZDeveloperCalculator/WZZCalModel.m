//
//  WZZCalModel.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZCalModel.h"

static WZZCalModel * model;

@interface WZZCalModel () {
    NSMutableArray * _calPad2;
    NSMutableArray * _calPad8;
    NSMutableArray * _calPad10;
    NSMutableArray * _calPad16;
}

@end

@implementation WZZCalModel

+ (instancetype)shareInstance {
    if (!model) {
        model = [[WZZCalModel alloc] init];
    }
    return model;
}

- (NSArray *)normalHandlePad {
    return @[
             @{@"title":@"+"},
             @{@"title":@"-"},
             @{@"title":@"x"},
             @{@"title":@"÷"},
             @{@"title":@"="},
             ];
}

- (NSMutableArray *)calPad10 {
    if (!_calPad10) {
        _calPad10 = [NSMutableArray array];
        [_calPad10 addObject:@{@"title":@"AC"}];
        //0123456789
        for (int i = 0; i < 10; i++) {
            [_calPad10 addObject:@{@"title":@(i).stringValue}];
        }
        
        //+-x÷=
        [_calPad10 addObjectsFromArray:[self normalHandlePad]];
    }
    _currentCalPad = _calPad10;
    return _calPad10;
}

- (NSMutableArray *)calPad2 {
    if (!_calPad2) {
        _calPad2 = [NSMutableArray array];
        [_calPad2 addObject:@{@"title":@"AC"}];
        [_calPad2 addObjectsFromArray:@[
                                   @{@"title":@"0"},
                                   @{@"title":@"1"},
                                   @{@"title":@"<<"},
                                   @{@"title":@">>"},
                                   @{@"title":@"|"},
                                   @{@"title":@"&"},
                                   @{@"title":@"^"},
                                   @{@"title":@"!"}
                                   ]];
        [_calPad2 addObjectsFromArray:[self normalHandlePad]];
    }
    _currentCalPad = _calPad2;
    return _calPad2;
}

- (NSMutableArray *)calPad8 {
    if (!_calPad8) {
        _calPad8 = [NSMutableArray array];
        [_calPad8 addObject:@{@"title":@"AC"}];
        for (int i = 0; i < 8; i++) {
            [_calPad8 addObject:@{@"title":@(i).stringValue}];
        }
        [_calPad8 addObjectsFromArray:[self normalHandlePad]];
    }
    _currentCalPad = _calPad8;
    return _calPad8;
}

- (NSMutableArray *)calPad16 {
    if (!_calPad16) {
        _calPad16 = [NSMutableArray array];
        [_calPad16 addObject:@{@"title":@"AC"}];
        for (int i = 0; i < 10; i++) {
            [_calPad16 addObject:@{@"title":@(i).stringValue}];
        }
        for (int i = 0; i < 5; i++) {
            [_calPad16 addObject:@{@"title":[NSString stringWithFormat:@"%c", 'A'+i]}];
        }
        [_calPad16 addObjectsFromArray:[self normalHandlePad]];
    }
    _currentCalPad = _calPad16;
    return _calPad16;
}

- (NSString *)handleText:(NSString *)text {
    if (_currentCalPad == _calPad10) {
        for (int i = 0; i < 10; i++) {
            if ([text isEqualToString:[NSString stringWithFormat:@"%d", i]]) {
                return text;
            }
        }
    } else if (_currentCalPad == _calPad2) {
        for (int i = 0; i < 2; i++) {
            if ([text isEqualToString:[NSString stringWithFormat:@"%d", i]]) {
                return text;
            }
        }
    } else if (_currentCalPad == _calPad8) {
        for (int i = 0; i < 8; i++) {
            if ([text isEqualToString:[NSString stringWithFormat:@"%d", i]]) {
                return text;
            }
        }
    } else if (_currentCalPad == _calPad16) {
        for (int i = 0; i < 16; i++) {
            if ([text isEqualToString:[NSString stringWithFormat:@"%d", i]]) {
                return text;
            }
        }
    }
    
    return @"";
}

@end
