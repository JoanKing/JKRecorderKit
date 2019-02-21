//
//  JKAudioFilePathTool.h
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/21.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKAudioFilePathTool : NSObject

#pragma mark 1、判断文件或文件夹是否存在
+(BOOL)jk_judgeFileOrFolderExists:(NSString *)filePathName;

#pragma mark 2、判断文件是否存在
/**
 判断文件是否存在
 
 @param filePath 文件路径
 @return YES:存在 NO:不存在
 */
+(BOOL)jk_judgeFileExists:(NSString *)filePath;

/**
 类方法创建文件夹目录

 @param folderName 文件夹的名字
 @return 返回一个路径
 */
+(NSString *)jk_createFolder:(NSString *)folderName;

@end

NS_ASSUME_NONNULL_END
