# JKRecorderKit
录音/压缩转码

使用方式如下：

    - <1>、导入 #import "JKRecorderKit.h"
    - <2>、使用 JKAudioTool 类进行调用 录音的一系列操作，如下
    
      - 开始录音
      
          // 目前使用 caf 格式, test2：录音的名字  caf:录音的格式
          [[JKAudioTool shareJKAudioTool]beginRecordWithRecordName:@"test2" withRecordType:@"caf" withIsConventToMp3:YES];
      - 完成录音
      
          [[JKAudioTool shareJKAudioTool]endRecord];
      - 暂停录音
      
          [[JKAudioTool shareJKAudioTool]pauseRecord];
      - 删除录音
      
          [[JKAudioTool shareJKAudioTool]deleteRecord];
      - caf 转 mp3
          // 第一个参数是原音频的路径，第二个参数是转换为 MP3 后是否删除原来的路径
          [JKLameTool audioToMP3:[cachesRecorderPath stringByAppendingPathComponent:@"test2.caf"] isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull resultPath) {
        
              NSLog(@"转为MP3后的路径=%@",resultPath);
        
          } withFailBack:^(NSString * _Nonnull error) {
              NSLog(@"转换失败：%@",error);
        
          }];
