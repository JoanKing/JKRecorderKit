//
//  JKAudioTool.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKAudioTool.h"
#import "JKAudioFilePathTool.h"
#import "JKLameTool.h"
@interface JKAudioTool()<AVAudioRecorderDelegate>

/**
 录音对象
 */
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

/**
 录音成功的block
 */
@property (nonatomic, copy) AudioSuccess block;

/**
 录音文件的名字
 */
@property (nonatomic, strong) NSString *audioFileName;

/**
 录音的类型
 */
@property (nonatomic, strong) NSString *recordType;

/**
 是否边录边转mp3
 */
@property (nonatomic, assign) BOOL isConventMp3;

@end

@implementation JKAudioTool

jkSingleM(JKAudioTool)

-(AVAudioRecorder *)audioRecorder
{
    __weak typeof(self) weakSelf = self;
    if (!_audioRecorder) {
        
        // 0. 设置录音会话
        /**
         AVAudioSessionCategoryPlayAndRecord: 可以边播放边录音(也就是平时看到的背景音乐)
         */
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        // 启动会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        // 1. 确定录音存放的位置
        NSURL *url = [NSURL URLWithString:weakSelf.recordPath];
        
        // 2. 设置录音参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        // 设置编码格式
        /**
         kAudioFormatLinearPCM: 无损压缩，内容非常大
         kAudioFormatMPEG4AAC
         */
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        // 采样率：必须保证和转码设置的相同
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
        // 通道数（必须设置为双声道, 不然转码生成的 MP3 会声音尖锐变声.）
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        
        //音频质量,采样质量(音频质量越高，文件的大小也就越大)
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        
        // 3. 创建录音对象
        NSError *error ;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        //开启音量监测
        _audioRecorder.meteringEnabled = YES;
        
        _audioRecorder.delegate = weakSelf;
        
        if(error){
            NSLog(@"创建录音对象时发生错误，错误信息：%@",error.localizedDescription);
        }
    }
    return _audioRecorder;
}

/** 开始录音 */
- (void)beginRecordWithRecordName: (NSString *)recordName withRecordType:(NSString *)type withIsConventToMp3:(BOOL)isConventToMp3{
    
    // 正在录制就返回，防止多次点击录音
    
    _recordType = type;
    _isConventMp3 = isConventToMp3;
    
    if ([recordName containsString:[NSString stringWithFormat:@".%@",_recordType]]) {
        
        _audioFileName = recordName;
    }else{
        
        _audioFileName = [NSString stringWithFormat:@"%@.%@",recordName,_recordType];
    }
    
    if (![JKAudioFilePathTool jk_judgeFileOrFolderExists:cachesRecorderPath]) {
        
        // 创建 /Library/Caches/JKRecorder 文件夹
        [JKAudioFilePathTool jk_createFolder:cachesRecorderPath];
    }
    
    // 创建录音文件存放路径
    _recordPath = [cachesRecorderPath stringByAppendingPathComponent:_audioFileName];
    
    // 准备录音
    if ([self.audioRecorder prepareToRecord]) {
        
        // 开始录音
        [self.audioRecorder record];
        
        // 判断是否需要边录边转 MP3
        if (isConventToMp3) {
            
            [[JKLameTool shareJKLameTool]audioRecodingToMP3:_recordPath isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull resultPath) {
                
            } withFailBack:^(NSString * _Nonnull error) {
                
            }];
        }
    
    }
}

/** 结束录音 */
- (void)endRecord {
    [self.audioRecorder stop];
    
}

/** 暂停录音 */
- (void)pauseRecord {
    [self.audioRecorder pause];
}

/** 删除录音 */
- (void)deleteRecord {
    [self.audioRecorder stop];
    // 删除录音之前必须先停止录音
    [self.audioRecorder deleteRecording];
}

/** 重新录音 */
- (void)reRecord {
    
    self.audioRecorder = nil;
    [self beginRecordWithRecordName:self.audioFileName withRecordType:self.recordType withIsConventToMp3:self.isConventMp3];
}

/**
 更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
 */
-(void)updateMeters
{
    [self.audioRecorder updateMeters];
}

/**
 获得指定声道的分贝峰值
 获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
 @return 指定频道的值
 */
- (float)peakPowerForChannel0{
    
    [self.audioRecorder updateMeters];
    return [self.audioRecorder peakPowerForChannel:0];
}

/**
 当前录音的时间
 */
-(NSTimeInterval)audioCurrentTime{
    
    return self.audioRecorder.currentTime;
}

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"----- 录音  完毕");
        
        if (self.isConventMp3) {
            
             [[JKLameTool shareJKLameTool] sendEndRecord];
        }
    }
}

@end
