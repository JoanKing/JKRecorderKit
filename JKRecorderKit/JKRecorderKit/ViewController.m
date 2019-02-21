//
//  ViewController.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/20.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "JKRecorderKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
    [buttton1 setTitle:@"开始录音" forState:UIControlStateNormal];
    [buttton1 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton1 setBackgroundColor:[UIColor yellowColor]];
    [buttton1 addTarget:self action:@selector(beginRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton1];
    
    UIButton *buttton12 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttton1.frame)+20, 100, 100, 40)];
    [buttton12 setTitle:@"暂停录音" forState:UIControlStateNormal];
    [buttton12 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton12 setBackgroundColor:[UIColor yellowColor]];
    [buttton12 addTarget:self action:@selector(pauseRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton12.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton12];
    
    UIButton *buttton2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton1.frame)+30, 100, 40)];
    [buttton2 setTitle:@"结束录音" forState:UIControlStateNormal];
    [buttton2 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton2 setBackgroundColor:[UIColor yellowColor]];
    [buttton2 addTarget:self action:@selector(endRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton2.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton2];
    
    UIButton *buttton3 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton2.frame)+30, 100, 40)];
    [buttton3 setTitle:@"删除录音" forState:UIControlStateNormal];
    [buttton3 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton3 setBackgroundColor:[UIColor yellowColor]];
    [buttton3 addTarget:self action:@selector(deleteRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton3.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton3];
    
    UIButton *buttton4 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton3.frame)+30, 100, 40)];
    [buttton4 setTitle:@"播放录音" forState:UIControlStateNormal];
    [buttton4 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton4 setBackgroundColor:[UIColor yellowColor]];
    [buttton4 addTarget:self action:@selector(playRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton4.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton4];
    
    UIButton *buttton5 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton4.frame)+30, 100, 40)];
    [buttton5 setTitle:@"拼接录音" forState:UIControlStateNormal];
    [buttton5 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton5 setBackgroundColor:[UIColor yellowColor]];
    [buttton5 addTarget:self action:@selector(editRecordClick) forControlEvents:UIControlEventTouchUpInside];
    buttton4.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton5];
    
    UIButton *buttton6 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton5.frame)+30, 110, 40)];
    [buttton6 setTitle:@"caf转mp3" forState:UIControlStateNormal];
    [buttton6 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton6 setBackgroundColor:[UIColor yellowColor]];
    [buttton6 addTarget:self action:@selector(pcmAudioToMP3Click) forControlEvents:UIControlEventTouchUpInside];
    buttton6.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton6];

}

#pragma mark 开始录音
-(void)beginRecordClick{
    
    // 不同的文件格式，存放不同的编码数据，caf结尾的文件，基本上可以存放任何苹果支持的编码格式
    [[JKAudioTool shareJKAudioTool]beginRecordWithRecordName:@"test6" withRecordType:@"caf" withIsConventToMp3:YES];
    
}

#pragma mark 暂停录音
-(void)pauseRecordClick{
    
    NSLog(@"暂停录音");
    
    [[JKAudioTool shareJKAudioTool]pauseRecord];
}

#pragma mark 结束录音
-(void)endRecordClick{
    
    [[JKAudioTool shareJKAudioTool]endRecord];
   
}

#pragma mark 删除录音
-(void)deleteRecordClick{
 
    [[JKAudioTool shareJKAudioTool]deleteRecord];
}

#pragma mark 播放录音
-(void)playRecordClick{
    
    [[JKAudioPlayerTool shareJKAudioPlayerTool] playAudioWith:[cachesRecorderPath stringByAppendingPathComponent:@"test6.mp3"]];
    [JKAudioPlayerTool shareJKAudioPlayerTool].span = 0;
}

#pragma mark 音频的拼接：追加某个音频在某个音频的后面
-(void)editRecordClick{
    
    [JKAudioFileTool addAudio:[cachesRecorderPath stringByAppendingPathComponent:@"test2.caf"] toAudio:[cachesRecorderPath stringByAppendingPathComponent:@"test1.caf"] outputPath:[cachesRecorderPath stringByAppendingPathComponent:@"test3.caf"]];
}

#pragma mark caf 转 mp3
-(void)pcmAudioToMP3Click{

    [JKLameTool audioToMP3:[cachesRecorderPath stringByAppendingPathComponent:@"test2.caf"] isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull resultPath) {
        
        NSLog(@"转为MP3后的路径=%@",resultPath);
        
    } withFailBack:^(NSString * _Nonnull error) {
        NSLog(@"转换失败：%@",error);
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"家目录=%@",NSHomeDirectory());
    
    NSString *name = @"hha.af";
    
    if ([name containsString:@".caf"]) {
        
        NSLog(@"包含 .caf");
    }else{
        
        NSLog(@"不包含 .caf");
    }
}

@end
