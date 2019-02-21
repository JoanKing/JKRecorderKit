//
//  JKAudioPlayerTool.h
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JKSingle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKAudioPlayerTool : NSObject

jkSingleH(JKAudioPlayerTool)

/** 播放歌曲 */
- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath;

/** 恢复当前歌曲播放 */
- (void)resumeCurrentAudio;

/** 暂停歌曲 */
- (void)pauseCurrentAudio;

/** 停止歌曲播放 */
- (void)stopCurrentAudio;

/**
   音量大小，范围0-1.0
 */
@property (nonatomic, assign) float volumn;

/** 播放进度大小 */
@property (nonatomic, assign, readonly) float progress;

/**
   是否允许改变播放速率
 */
@property (nonatomic, assign) BOOL enableRate;

/**
 播放速率，范围0.5-2.0，如果为1.0则正常播放，如果要修改播放速率则必须设置enableRate为YES
 */
@property (nonatomic, assign) float rate;

/**
  立体声平衡
  如果为-1.0则完全左声道，如果0.0则左右声道平衡，如果为1.0则完全为右声道
  */
@property (nonatomic, assign) float span;

/**
 循环播放次数，如果为0则不循环，如果小于0则无限循环，大于0则表示循环次数
 */
@property (nonatomic, assign) NSInteger numberOfLoops;

@end

NS_ASSUME_NONNULL_END
