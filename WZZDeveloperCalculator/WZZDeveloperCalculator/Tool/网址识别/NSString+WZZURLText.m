//
//  NSString+WZZURLText.m
//  wdquan
//
//  Created by 舞蹈圈 on 17/1/6.
//  Copyright © 2017年 wdquan. All rights reserved.
//

#import "NSString+WZZURLText.h"

#pragma mark - NSString分类
@implementation NSString (WZZURLText)

//URL范围
- (NSArray <WZZSubUrlModel *>*)rangeOfURLString {
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableArray * mutArr = [NSMutableArray array];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [self substringWithRange:match.range];
        WZZSubUrlModel * model = [[WZZSubUrlModel alloc] init];
        model.subUrlString = substringForMatch;
        model.subUrlRange = match.range;
        [mutArr addObject:model];
    }
    
    return mutArr;
}

@end

#pragma mark - NSMutableString分类

@implementation NSMutableString (WZZURLText)

//URL范围
- (NSArray<WZZSubUrlModel *> *)rangeOfURLString {
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableArray * mutArr = [NSMutableArray array];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [self substringWithRange:match.range];
        WZZSubUrlModel * model = [[WZZSubUrlModel alloc] init];
        model.subUrlString = substringForMatch;
        model.subUrlRange = match.range;
        [mutArr addObject:model];
    }
    
    return mutArr;
}

//替换URL
- (NSArray<WZZSubUrlModel *> *)rangeOfReplaceUrlStringWithString:(NSString *)string {
    NSArray <WZZSubUrlModel *>* arr = [self rangeOfURLString];
    __block NSInteger jian = 0;
    NSMutableArray <WZZSubUrlModel *>* returnArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(WZZSubUrlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self replaceCharactersInRange:NSMakeRange(obj.subUrlRange.location-jian, obj.subUrlRange.length) withString:string];
        
        WZZSubUrlModel * model = [[WZZSubUrlModel alloc] init];
        model.subUrlString = obj.subUrlString;
        model.subUrlRange = NSMakeRange(obj.subUrlRange.location-jian, string.length);
        [returnArr addObject:model];
        
        jian += obj.subUrlRange.length-string.length;
    }];
    
    return returnArr;
}

@end

#pragma mark - NSMutableAttributedString分类
@implementation NSMutableAttributedString (WZZURLText)

//URL范围
- (NSArray<WZZSubUrlModel *> *)rangeOfURLString {
    return [self.string rangeOfURLString];
}

//替换URL
- (NSArray<WZZSubUrlModel *> *)rangeOfReplaceUrlStringWithAttributedString:(NSAttributedString *)attributedString {
    NSArray <WZZSubUrlModel *>* arr = [self rangeOfURLString];
    __block NSInteger jian = 0;
    NSMutableArray <WZZSubUrlModel *>* returnArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(WZZSubUrlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self replaceCharactersInRange:NSMakeRange(obj.subUrlRange.location-jian, obj.subUrlRange.length) withAttributedString:attributedString];
        
        WZZSubUrlModel * model = [[WZZSubUrlModel alloc] init];
        model.subUrlString = obj.subUrlString;
        model.subUrlRange = NSMakeRange(obj.subUrlRange.location-jian, attributedString.length);
        [returnArr addObject:model];
        
        jian += obj.subUrlRange.length-attributedString.length;
    }];
    
    return returnArr;
}

@end

#pragma mark - 数据模型
@implementation WZZSubUrlModel

@end
