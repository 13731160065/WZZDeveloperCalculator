//
//  WZZSecret.m
//  WZZSecretDemo
//
//  Created by 王泽众 on 2017/8/21.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "WZZSecret.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation WZZSecret

#pragma mark - 散列算法
#pragma mark MD5
//MD5
+ (NSString *)MD5WithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

#pragma mark SHA1
//SHA1
+ (NSString *)SHA1WithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)SHA256WithString:(NSString *)string {
    NSData *keyData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData * outData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [outData description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

#pragma mark - 对称算法
#pragma mark base64
//base64编码
+ (NSString *)base64EncryptWithData:(NSString *)string {
    return [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

//base64解码
+ (NSString *)base64DecryptWithData:(NSString *)string {
    NSData * decodeData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

#pragma mark AES256(暂不可用)
//AES加密
+ (NSString *)AES256EncryptWithString:(NSString *)aString key:(NSString *)key {
    NSData * data = [aString dataUsingEncoding:NSUTF8StringEncoding];
    //AES256的密钥允许32个字节，否则将为空的密钥(空填充)
    char keyPtr[kCCKeySizeAES256+1]; //key的空间
    bzero(keyPtr, sizeof(keyPtr)); //用0填充
    
    //获取密钥数据
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    //见文档:对于分组密钥，输出大小总是小于等于输入大小加上一组密钥大小，这就是为什么要加一组密钥大小
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          NULL, //初始化向量(可选，见CCCrypt声明)
                                          [data bytes],
                                          dataLength,//输入
                                          buffer,
                                          bufferSize, //输出
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //用buffer生成NSData数据
        NSData * returnData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [self hexStringWithData:returnData];
    }
    
    free(buffer);//释放buffer;
    return nil;
}

//AES解密
+ (NSString *)AES256DecryptWithString:(NSString *)aString key:(NSString *)key {
    NSData * data = [self dataWithHEXString:aString];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));

    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return nil;
}

#pragma mark AES128
//AES加密
+ (NSString *)AES128EncryptWithString:(NSString *)aString key:(NSString *)key {
    NSData * data = [aString dataUsingEncoding:NSUTF8StringEncoding];
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [self hexStringWithData:resultData];
    }
    free(buffer);
    return nil;
}

//AES解密
+ (NSString *)AES128DecryptWithString:(NSString *)aString key:(NSString *)key {
    NSData * data = [self dataWithHEXString:aString];
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

#pragma mark DES
//DES加密
+ (NSString *)DESEncryptWithString:(NSString *)string key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024 * 5];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self hexStringWithData:data];
    }
    return ciphertext;
}

//对应DES解密
+ (NSString *)DESDecryptWithString:(NSString *)string key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [self dataWithHEXString:string];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024 * 5];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

#pragma mark 3DES
//3DES加密
+ (NSString *)DES3EncryptWithString:(NSString *)string key:(NSString *)key {
    if (key.length != 32) {
        return nil;
    }
    if (string.length != 16 && string.length != 32) {
        return nil;
    }
    
    NSString * keyT8 = [key substringToIndex:16];
    NSString * keyF8 = [key substringFromIndex:16];
    NSString * text11 = [self _3DESEncryptWithString:[string substringToIndex:16] key:keyT8];
    NSString * text12 = [self _3DESDecryptWithString:text11 key:keyF8];
    NSString * text13 = [self _3DESEncryptWithString:text12 key:keyT8];
    
    NSString * text21;
    NSString * text22;
    NSString * text23;
    if (string.length > 16) {
       text21 = [self DESEncryptWithString:[string substringFromIndex:16] key:keyT8];
       text22 = [self _3DESDecryptWithString:text21 key:keyF8];
       text23 = [self _3DESEncryptWithString:text22 key:keyT8];
    }
    
    if (text13 && text23) {
        return [text13 stringByAppendingString:text23];
    }
    
    if (text13) {
        return text13;
    }
    
    return nil;
}

//3DES解密
+ (NSString *)DES3DecryptWithString:(NSString *)string key:(NSString *)key {
    if (key.length != 32) {
        return nil;
    }
    if (string.length != 16 && string.length != 32) {
        return nil;
    }
    
    NSString * keyT8 = [key substringToIndex:16];
    NSString * keyF8 = [key substringFromIndex:16];
    NSString * text11 = [self _3DESDecryptWithString:[string substringToIndex:16] key:keyT8];
    NSString * text12 = [self _3DESEncryptWithString:text11 key:keyF8];
    NSString * text13 = [self _3DESDecryptWithString:text12 key:keyT8];
    
    NSString * text21;
    NSString * text22;
    NSString * text23;
    if (string.length > 16) {
        text21 = [self DESDecryptWithString:[string substringFromIndex:16] key:keyT8];
        text22 = [self _3DESEncryptWithString:text21 key:keyF8];
        text23 = [self _3DESDecryptWithString:text22 key:keyT8];
    }
    
    if (text13 && text23) {
        return [text13 stringByAppendingString:text23];
    }
    if (text13) {
        return text13;
    }
    return nil;
}

//3DES需要调用的DES加密
+ (NSString *)_3DESEncryptWithString:(NSString *)string key:(NSString *)key {
    if (string.length != 16 || key.length != 16) {
        return nil;
    }
    NSData * data = [self dataWithHEXString:string];
    NSData * keyData = [self dataWithHEXString:key];
    uint8_t tmp[1024];
    void *bufferPtr = NULL;
    NSInteger bufferPtrSize = data.length;
    
    if (data.length > 1024) {
        bufferPtr = (void*)malloc(data.length);
    }else{
        bufferPtr = tmp;
    }
    
    size_t datalen = 0;
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionECBMode,
                                       keyData.bytes,
                                       keyData.length,
                                       NULL,
                                       data.bytes,
                                       data.length,
                                       bufferPtr,
                                       bufferPtrSize,
                                       &datalen);
    
    NSData * cryptData;
    if (ccStatus == kCCSuccess) {
        cryptData = [NSData dataWithBytes:(const void*)bufferPtr length:datalen];
    }
    
    if (bufferPtr != tmp) {
        free(bufferPtr);
        bufferPtr = NULL;
    }
    
    NSString * returnStr = nil;
    if (cryptData) {
        returnStr = [self hexStringWithData:cryptData];
    }
    return returnStr;
}

//3DES需要调用的DES解密
+ (NSString *)_3DESDecryptWithString:(NSString *)string key:(NSString *)key {
    if (string.length != 16 || key.length != 16) {
        return nil;
    }
    NSData * data = [self dataWithHEXString:string];
    NSData * keyData = [self dataWithHEXString:key];
    uint8_t tmp[1024];
    void *bufferPtr = NULL;
    NSInteger bufferPtrSize = data.length;
    
    if (data.length > 1024) {
        bufferPtr = (void*)malloc(data.length);
    }else{
        bufferPtr = tmp;
    }
    
    size_t datalen = 0;
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionECBMode,
                                       keyData.bytes,
                                       keyData.length,
                                       NULL,
                                       data.bytes,
                                       data.length,
                                       bufferPtr,
                                       bufferPtrSize,
                                       &datalen);
    
    NSData * cryptData;
    if (ccStatus == kCCSuccess) {
        cryptData = [NSData dataWithBytes:(const void*)bufferPtr length:datalen];
    }
    
    if (bufferPtr != tmp) {
        free(bufferPtr);
        bufferPtr = NULL;
    }
    
    NSString * returnStr = nil;
    if (cryptData) {
        returnStr = [self hexStringWithData:cryptData];
    }
    return returnStr;
}

#pragma mark - 非对称算法

#pragma mark - 其他方法
//data转换成十六进制字符串
+ (NSString*)hexStringWithData:(NSData *)data {
    NSMutableString *arrayString = [[NSMutableString alloc]initWithCapacity:data.length * 2];
    int len = (int)data.length;
    unsigned char* bytes = (unsigned char*)data.bytes;
    
    for (int i = 0; i < len; i++) {
        unsigned char cValue = bytes[i];
        
        //        int iValue = cValue;
        //        iValue = iValue & 0x000000FF;
        
        NSString *str = [NSString stringWithFormat:@"%02x",cValue];
        
        [arrayString appendString:str];
    }
    
    return arrayString.uppercaseString;
}

//16进制字符串转data
+ (NSData*)dataWithHEXString:(NSString *)hexStr {
    const char * ch = [[hexStr lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        } else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
    
}

@end
