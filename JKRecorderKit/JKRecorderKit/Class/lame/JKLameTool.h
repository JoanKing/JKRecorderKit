//
//  JKLameTool.h
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/21.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKSingle.h"
NS_ASSUME_NONNULL_BEGIN

@interface JKLameTool : NSObject

jkSingleH(JKLameTool)

#pragma mark caf 转 mp3 ： 录音完成后根据用户需要去调用
/**
 caf 转 mp3

 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
+(void)audioToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail;

#pragma mark caf 转 mp3 : 录音的同时转码
/**
 caf 转 mp3 : 录音的同时转码
 
 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
-(void)audioRecodingToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail;

#pragma mark 录音完成的调用
/**
  录音完成的调用
 */
- (void)sendEndRecord;

@end

NS_ASSUME_NONNULL_END
