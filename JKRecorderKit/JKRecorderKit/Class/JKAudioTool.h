//
//  JKAudioTool.h
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
// 单利的类
#import "JKSingle.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

// 录音存放的文件夹 /Library/Caches/JKRecorder
#define cachesRecorderPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/JKRecorder"]

typedef void(^AudioSuccess)(BOOL ret);

@interface JKAudioTool : NSObject

jkSingleH(JKAudioTool)

/** 录音文件路径 */
@property (nonatomic, copy, readonly) NSString *recordPath;

/** 当前录音的时间 */
@property(nonatomic,assign) NSTimeInterval audioCurrentTime;

#pragma mark 开始录音
/**
 开始录音
 @param recordName 录音的名字
 */
- (void)beginRecordWithRecordName:(NSString *)recordName withRecordType:(NSString *)type withIsConventToMp3:(BOOL)isConventToMp3;

#pragma mark 结束录音
/** 结束录音 */
- (void)endRecord;

#pragma mark 暂停录音
/** 暂停录音 */
- (void)pauseRecord;

#pragma mark 删除录音
/** 删除录音 */
- (void)deleteRecord;

#pragma mark 重新录音
/** 重新录音 */
- (void)reRecord;

#pragma mark 更新音频测量值
/**
 更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
 @property(getter=isMeteringEnabled) BOOL meteringEnabled：是否启用音频测量，默认为NO，一旦启用音频测量可以通过updateMeters方法更新测量值
 */
- (void)updateMeters;

#pragma mark 获得指定声道的分贝峰值
/**
 获得指定声道的分贝峰值
 获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
 @return 指定频道的值
 */
- (float)peakPowerForChannel0;

@end

NS_ASSUME_NONNULL_END
