//
//  JKAudioFilePathTool.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/21.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKAudioFilePathTool.h"

@implementation JKAudioFilePathTool

#pragma mark 1、判断文件或文件夹是否存在
+(BOOL)jk_judgeFileOrFolderExists:(NSString *)filePathName{
    
    // 长度等于0，直接返回不存在
    if (filePathName.length == 0) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@",filePathName];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        
        // 不存在的路径才会创建
        return NO;
    }else{
        
        return YES;
    }
    return nil;
}

+(BOOL)jk_judgeFileExists:(NSString *)filePath{
    
    // 长度等于0，直接返回不存在
    if (filePath.length == 0) {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@",filePath];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if (existed == YES) {
        
        return YES;
    }else{
        // 不存在
        return NO;
    }
    return nil;
}

/**类方法创建文件夹目录 folderNmae:文件夹的名字*/
+(NSString *)jk_createFolder:(NSString *)folderName{
    
    // NSHomeDirectory()：应用程序目录， Caches、Library、Documents目录文件夹下创建文件夹(蓝色的)
    // @"Documents/JKPdf"
    NSString *filePath = [NSString stringWithFormat:@"%@",folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        
        // 不存在的路径才会创建
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}


@end
