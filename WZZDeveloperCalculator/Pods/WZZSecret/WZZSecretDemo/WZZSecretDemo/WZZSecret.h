//
//  WZZSecret.h
//  WZZSecretDemo
//
//  Created by 王泽众 on 2017/8/21.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZSecret : NSObject

#pragma mark - 散列算法
#pragma mark MD5

/**
 MD5加密

 @param string 明文
 @return 密文
 */
+ (NSString *)MD5WithString:(NSString *)string;

#pragma mark SHA1

/**
 SHA1加密

 @param string 明文
 @return 密文
 */
+ (NSString *)SHA1WithString:(NSString *)string;

/**
 SHA256加密

 @param string 明文
 @return 密文
 */
+ (NSString *)SHA256WithString:(NSString *)string;

#pragma mark - 对称算法
#pragma mark base64编码

/**
 base64编码

 @param string 待编码字符串
 @return 编码后字符串
 */
+ (NSString *)base64EncryptWithData:(NSString *)string;


/**
 base64解码

 @param string 待解码字符串
 @return 解码后字符串
 */
+ (NSString *)base64DecryptWithData:(NSString *)string;

#pragma mark AES
/**
 AES128位加密

 @param aString 明文数据
 @param key 密钥
 @return 密文数据
 */
+ (NSString *)AES128EncryptWithString:(NSString *)aString key:(NSString *)key;

/**
 AES128位解密

 @param aString 密文数据
 @param key 密钥
 @return 明文数据
 */
+ (NSString *)AES128DecryptWithString:(NSString *)aString key:(NSString *)key;

#pragma mark DES

/**
 DES加密

 @param data 明文数据
 @param key 密钥
 @return 密文数据
 */
+ (NSString *)DESEncryptWithString:(NSString *)data
                               key:(NSString *)key;


/**
 DES解密

 @param data 密文数据
 @param key 密钥
 @return 明文数据
 */
+ (NSString *)DESDecryptWithString:(NSString *)data
                               key:(NSString *)key;

#pragma mark 3DES
/**
 3DES加密

 @param string 明文数据
 @param key 密钥
 @return 密文数据
 */
+ (NSString *)DES3EncryptWithString:(NSString *)string
                                key:(NSString *)key;

/**
 3DES解密

 @param string 密文数据
 @param key 密钥
 @return 明文数据
 */
+ (NSString *)DES3DecryptWithString:(NSString *)string
                                key:(NSString *)key;

#pragma mark - 非对称算法


#pragma mark - 辅助方法

/**
 data转16进制字符串

 @param data 数据
 @return 16进制字符串
 */
+ (NSString*)hexStringWithData:(NSData *)data;

/**
 16进制字符串转data

 @param hexStr 16进制字符串
 @return 数据
 */
+ (NSData*)dataWithHEXString:(NSString *)hexStr;

@end
