//
//  NSString+WZZURLText.h
//  wdquan
//
//  Created by 舞蹈圈 on 17/1/6.
//  Copyright © 2017年 wdquan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WZZSubUrlModel;


#pragma mark - NSString分类
@interface NSString (WZZURLText)

/**
 找到url在文字中的位置
 */
- (NSArray <WZZSubUrlModel *>*)rangeOfURLString;

@end

#pragma mark - NSMutableString分类
@interface NSMutableString (WZZURLText)

/**
 找到url在文字中的位置
 */
- (NSArray <WZZSubUrlModel *>*)rangeOfURLString;

/**
 用文本替换url并返回替换后的位置
 string   用这个文本字符串替换url
 */
- (NSArray <WZZSubUrlModel *>*)rangeOfReplaceUrlStringWithString:(NSString *)string;

@end

#pragma mark - NSMutableAttributedString分类
@interface NSMutableAttributedString (WZZURLText)

/**
 找到url在文字中的位置
 */
- (NSArray <WZZSubUrlModel *>*)rangeOfURLString;

/**
 用富文本替换url并返回替换后的位置
 AttributedString   用这个富文本字符串替换url
 */
- (NSArray <WZZSubUrlModel *>*)rangeOfReplaceUrlStringWithAttributedString:(NSAttributedString *)attributedString;

@end

#pragma mark - 数据模型
@interface WZZSubUrlModel : NSObject

/**
 url字符串
 */
@property (strong, nonatomic) NSString * subUrlString;

/**
 url位置
 */
@property (assign, nonatomic) NSRange subUrlRange;

@end
