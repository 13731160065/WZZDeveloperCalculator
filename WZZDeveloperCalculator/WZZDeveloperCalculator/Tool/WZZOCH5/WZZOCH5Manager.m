//
//  WZZOCH5Manager.m
//  WZZOCH5Demo
//
//  Created by 王泽众 on 2017/9/26.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "WZZOCH5Manager.h"
#import "ZipArchive.h"

#define WZZOCH5Manager_unzipDir @"Documents/unzipDir"
#define WZZOCH5Manager_unzipName @"www"

static WZZOCH5Manager * wzzOCH5Manager;

@implementation WZZOCH5Manager

+ (NSString *)wwwDir {
    //返回正确的地址
    if ([[NSFileManager defaultManager] isExecutableFileAtPath:[NSString stringWithFormat:@"%@/%@/%@_2", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName]]) {
        return [NSString stringWithFormat:@"%@/%@/%@_2", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName];
    } else if ([[NSFileManager defaultManager] isExecutableFileAtPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName]]) {
        return [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName];
    }
    return nil;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wzzOCH5Manager = [[WZZOCH5Manager alloc] init];
    });
    return wzzOCH5Manager;
}

+ (void)unzipToBundleWithData:(NSData *)data {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //如果没有这个文件夹就创建
    if (![fileManager isExecutableFileAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir]]) {
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir] withIntermediateDirectories:NO attributes:nil error:nil];
    }

    //用下载文件创建zip
    [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@/%@.zip", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] contents:data attributes:nil];
    
    //解压缩成文件夹_2
    BOOL unzipOK = [SSZipArchive unzipFileAtPath:[NSString stringWithFormat:@"%@/%@/%@.zip", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] toDestination:[NSString stringWithFormat:@"%@/%@/%@_3", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName]];
    
    //这里会分化成两个文件夹，为了避免webview的缓存
    if (unzipOK) {
        //解压缩成功
        if ([fileManager isExecutableFileAtPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName]]) {
            //删除旧的文件夹1
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
            //将解压的文件夹_3换成文件夹_2
            [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@/%@_3", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] toPath:[NSString stringWithFormat:@"%@/%@/%@_2", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
        } else if ([fileManager isExecutableFileAtPath:[NSString stringWithFormat:@"%@/%@/%@_2", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName]]) {
            //删除旧的文件夹1
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@_2", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
            //将解压的文件夹_3换成文件夹1
            [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@/%@_3", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] toPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
        } else {
            //没有旧的文件夹
            //将解压的文件夹_3换成文件夹1
            [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@/%@_3", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] toPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
        }
    }
    
    //移除zip包
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@.zip", NSHomeDirectory(), WZZOCH5Manager_unzipDir, WZZOCH5Manager_unzipName] error:nil];
}

@end
