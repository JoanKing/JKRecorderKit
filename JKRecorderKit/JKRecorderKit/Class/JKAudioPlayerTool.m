//
//  JKAudioPlayerTool.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKAudioPlayerTool.h"

@interface JKAudioPlayerTool()<AVAudioPlayerDelegate>

/** 音乐播放器 */
@property (nonatomic ,strong) AVAudioPlayer *player;

@end

@implementation JKAudioPlayerTool

jkSingleM(JKAudioPlayerTool)

/** 播放歌曲 */
- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath
{
    
    NSURL *url = [NSURL URLWithString:audioPath];
    if (url == nil) {
        url = [[NSBundle mainBundle] URLForResource:audioPath.lastPathComponent withExtension:nil];
    }
    /**
     使用文件URL初始化播放器，注意这个URL不能是HTTP URL，AVAudioPlayer不支持加载网络媒体流，只能播放本地文件
     */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    /**
     加载音频文件到缓冲区，注意即使在播放之前音频文件没有加载到缓冲区程序也会隐式调用此方法。
     */
    [self.player prepareToPlay];
    /**
     播放音频文件
     */
    [self.player play];
    return self.player;
}

/** 恢复当前歌曲 */
- (void)resumeCurrentAudio
{
    [self.player play];
}

/** 暂停歌曲 */
- (void)pauseCurrentAudio
{
    [self.player pause];
}

/** 停止歌曲 */
- (void)stopCurrentAudio
{
    [self.player stop];
}

-(void)setVolumn:(float)volumn
{
    self.player.volume = volumn;
}

-(float)volumn
{
    return self.player.volume;
}

-(float)progress {
    return self.player.currentTime / self.player.duration;
}


-(void)setEnableRate:(BOOL)enableRate{
    
    [self.player setEnableRate:enableRate];
}

-(BOOL)enableRate{
    
    return self.enableRate;
}

-(void)setRate:(float)rate{
    
    [self.player setRate:rate];
}

-(float)rate{
    
    return self.rate;
}

-(void)setSpan:(float)span{
    
    [self.player setPan:span];
}

-(float)span{
    
    return self.span;
}

-(void)setNumberOfLoops:(NSInteger)numberOfLoops{
    
    [self.player setNumberOfLoops:numberOfLoops];
}

-(NSInteger)numberOfLoops{
    
    return self.numberOfLoops;
}

#pragma mark --- AVAudioPlayerDelegate-----

#pragma mark 音频播放完成
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"音频播放完成");
}

#pragma mark 音频解码发生错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    NSLog(@"音频解码发生错误");
}

@end

