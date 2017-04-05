//
//  WZZCalModel.h
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZCalModel : NSObject

@property (strong, nonatomic, readonly) NSMutableArray * calPad10;
@property (strong, nonatomic, readonly) NSMutableArray * calPad2;
@property (strong, nonatomic, readonly) NSMutableArray * calPad8;
@property (strong, nonatomic, readonly) NSMutableArray * calPad16;
@property (strong, nonatomic, readonly) NSMutableArray * currentCalPad;
@property (strong, nonatomic, readonly) NSMutableArray * padsArr;
@property (strong, nonatomic) NSString * currentNum;
@property (nonatomic, strong) NSString * d1;
@property (nonatomic, strong) NSString * op;
@property (nonatomic, strong) NSString * d2;

+ (instancetype)shareInstance;
- (NSString *)handleText:(NSString *)text;

@end
