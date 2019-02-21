//
//  JKAudioFileTool.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKAudioFileTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation JKAudioFileTool

#pragma mark 音频的拼接：追加某个音频在某个音频的后面
/**
 音频的拼接
 
 @param fromPath 前段音频路径
 @param toPath 后段音频路径
 @param outputPath 拼接后的音频路径
 */
+(void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath{
    
    // 1. 获取两个音频源
    AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:toPath]];
    
    // 2. 获取两个音频素材中的素材轨道
    AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *audioAssetTrack2 = [[audioAsset2 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    // 3. 向音频合成器, 添加一个空的素材容器
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    // 4. 向素材容器中, 插入音轨素材
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack2 atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:audioAsset2.duration error:nil];
    
    // 5. 根据合成器, 创建一个导出对象, 并设置导出参数
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    session.outputFileType = AVFileTypeMPEGLayer3;
    
    // 6. 开始导出数据
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        AVAssetExportSessionStatus status = session.status;
        
        NSString *statusStr = [weakSelf outputStatus:status];
        
        NSLog(@"%@",statusStr);
       
    }];
    
}

#pragma mark 音频的剪切
/**
 音频的剪切
 
 @param audioPath 要剪切的音频路径
 @param fromTime 开始剪切的时间
 @param toTime 结束剪切的时间
 @param outputPath 剪切成功后的音频路径
 */
+(void)cutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputPath:(NSString *)outputPath{
    
    // 1. 获取音频源
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    // AVFileTypeAppleM4A :  导出
    session.outputFileType = AVFileTypeAppleM4A;
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    CMTime startTime = CMTimeMake(fromTime, 1);
    CMTime endTime = CMTimeMake(toTime, 1);
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    // 3. 导出
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
       
        AVAssetExportSessionStatus status = session.status;
        
        NSString *statusStr = [weakSelf outputStatus:status];
        
        NSLog(@"%@",statusStr);
  
    }];
}

+(NSString *)outputStatus:(AVAssetExportSessionStatus)status{
    
    /**
     AVAssetExportSessionStatusUnknown,
     AVAssetExportSessionStatusWaiting,
     AVAssetExportSessionStatusExporting,
     AVAssetExportSessionStatusCompleted,
     AVAssetExportSessionStatusFailed,
     AVAssetExportSessionStatusCancelled
     */
    NSString *statusStr = @"";
    switch (status) {
        case AVAssetExportSessionStatusUnknown:
            // NSLog(@"未知状态");
            statusStr = @"未知状态";
            break;
        case AVAssetExportSessionStatusWaiting:
            NSLog(@"等待导出");
            statusStr = @"等待导出";
            break;
        case AVAssetExportSessionStatusExporting:
            NSLog(@"导出中");
            break;
        case AVAssetExportSessionStatusCompleted:{
            
            // NSLog(@"导出成功，路径是：%@", outputPath);
            statusStr = @"导出成功";
        }
            break;
        case AVAssetExportSessionStatusFailed:
            
            NSLog(@"导出失败");
            statusStr = @"导出失败";
            break;
        case AVAssetExportSessionStatusCancelled:
            NSLog(@"取消导出");
            statusStr = @"取消导出";
            break;
        default:
            break;
    }
    
    return statusStr;
    
}

#pragma mark m4a格式转caf格式
/**
 把.m4a转为.caf格式
 @param originalUrlStr .m4a文件路径
 @param destUrlStr .caf文件路径
 @param completed 转化完成的block
 */
+ (void)convetM4aToWav:(NSString *)originalUrlStr
               destUrl:(NSString *)destUrlStr
             completed:(void (^)(NSError *error)) completed {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destUrlStr]) {
        [[NSFileManager defaultManager] removeItemAtPath:destUrlStr error:nil];
    }
    NSURL *originalUrl = [NSURL fileURLWithPath:originalUrlStr];
    NSURL *destUrl     = [NSURL fileURLWithPath:destUrlStr];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:originalUrl options:nil];
    
    //读取原始文件信息
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (![assetReader canAddOutput:assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        completed(error);
        return;
    }
    [assetReader addOutput:assetReaderOutput];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:destUrl
                                                          fileType:AVFileTypeCoreAudioFormat
                                                             error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        completed(error);
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime:startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 NSLog (@"appended a buffer (%zu bytes)",
                           CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 
             } else {
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWritingWithCompletionHandler:^{
                     
                 }];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:[destUrl path]
                                                       error:nil];
                 NSLog (@"FlyElephant %lld",[outputFileAttributes fileSize]);
                 break;
             }
         }
         NSLog(@"转换结束");
         // 删除临时temprecordAudio.m4a文件
         NSError *removeError = nil;
         if ([[NSFileManager defaultManager] fileExistsAtPath:originalUrlStr]) {
             BOOL success = [[NSFileManager defaultManager] removeItemAtPath:originalUrlStr error:&removeError];
             if (!success) {
                 NSLog(@"删除临时temprecordAudio.m4a文件失败:%@",removeError);
                 completed(removeError);
             }else{
                 NSLog(@"删除临时temprecordAudio.m4a文件:%@成功",originalUrlStr);
                 completed(removeError);
             }
         }
         
     }];
}

/**
 把.caf转为.m4a格式
 @param cafUrlStr .m4a文件路径
 @param m4aUrlStr .caf文件路径
 @param completed 转化完成的block
 */
+ (void)convetCafToM4a:(NSString *)cafUrlStr
               destUrl:(NSString *)m4aUrlStr
             completed:(void (^)(NSError *error)) completed {
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    //  音频插入的开始时间
    CMTime beginTime = kCMTimeZero;
    //  获取音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //  用于记录错误的对象
    NSError *error = nil;
    //  音频原文件资源
    AVURLAsset *cafAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:cafUrlStr] options:nil];
    //  原音频需要合并的音频文件的区间
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, cafAsset.duration);
    BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[cafAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:beginTime error:&error];
    if (!success) {
        NSLog(@"插入原音频失败: %@",error);
    }else {
        NSLog(@"插入原音频成功");
    }
    // 创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    // 导入音视频的URL
    assetExport.outputURL = [NSURL fileURLWithPath:m4aUrlStr];
    // 导出音视频的文件格式
    assetExport.outputFileType = @"com.apple.m4a-audio";
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        // 分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            int exportStatus = assetExport.status;
            if (exportStatus == AVAssetExportSessionStatusCompleted) {
                // 合成成功
                completed(nil);
                NSError *removeError = nil;
                if([cafUrlStr hasSuffix:@"caf"]) {
                    // 删除老录音caf文件
                    if ([[NSFileManager defaultManager] fileExistsAtPath:cafUrlStr]) {
                        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:cafUrlStr error:&removeError];
                        if (!success) {
                            NSLog(@"删除老录音caf文件失败:%@",removeError);
                        }else{
                            NSLog(@"删除老录音caf文件:%@成功",cafUrlStr);
                        }
                    }
                }
                
            }else {
                completed(assetExport.error);
            }
            
        });
    }];
}



@end
