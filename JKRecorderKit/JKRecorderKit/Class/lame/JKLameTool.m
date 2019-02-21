//
//  JKLameTool.m
//  JKRecorderKit
//
//  Created by 王冲 on 2019/2/21.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKLameTool.h"
#import "lame.h"

@interface JKLameTool()

@property (nonatomic, assign) BOOL stopRecord;

@end

@implementation JKLameTool

jkSingleM(JKLameTool)

/**
 caf 转 mp3
 如果录音时间比较长的话,会要等待几秒...
 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
+ (void)audioToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        // 输入路径
        NSString *inPath = sourcePath;
        
        // 判断输入路径是否存在
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:sourcePath])
        {
            if (fail) {
                fail(@"文件不存在");
            }
            return;
        }
        
        // 输出路径
        NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
        
        @try {
            int read, write;
            
            FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                size_t size = (size_t)(2 * sizeof(short int));
                read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        
        @finally {
            
            if (isDelete) {
                
                NSError *error;
                [fm removeItemAtPath:sourcePath error:&error];
                if (error == nil)
                {
                    // NSLog(@"删除源文件成功");
                }
            }
            
            if (success) {
                success(outPath);
            }
        }
        
    });

}

#pragma mark caf 转 mp3 : 录音的同时转码
/**
 caf 转 mp3 : 录音的同时转码
 
 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
-(void)audioRecodingToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail{
    
    NSLog(@"convert begin!!");
    
    // 输入路径
    NSString *inPath = sourcePath;
    
    // 判断输入路径是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath])
    {
        if (fail) {
            fail(@"文件不存在");
        }
        return;
    }
    
    // 输出路径
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        weakself.stopRecord = NO;
        
        @try {
            
            int read, write;
            
            FILE *pcm = fopen([inPath cStringUsingEncoding:NSASCIIStringEncoding], "rb");
            FILE *mp3 = fopen([outPath cStringUsingEncoding:NSASCIIStringEncoding], "wb+");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE * 2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            long curpos;
            BOOL isSkipPCMHeader = NO;
            
            do {
                curpos = ftell(pcm);
                long startPos = ftell(pcm);
                fseek(pcm, 0, SEEK_END);
                long endPos = ftell(pcm);
                long length = endPos - startPos;
                fseek(pcm, curpos, SEEK_SET);
                
                if (length > PCM_SIZE * 2 * sizeof(short int)) {
                    
                    if (!isSkipPCMHeader) {
                        //Uump audio file header, If you do not skip file header
                        //you will heard some noise at the beginning!!!
                        fseek(pcm, 4 * 1024, SEEK_CUR);
                        isSkipPCMHeader = YES;
                        NSLog(@"skip pcm file header !!!!!!!!!!");
                    }
                    
                    read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                    fwrite(mp3_buffer, write, 1, mp3);
                    NSLog(@"read %d bytes", write);
                } else {
                    [NSThread sleepForTimeInterval:0.05];
                    NSLog(@"sleep");
                }
                
            } while (!weakself.stopRecord);
            
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            NSLog(@"read %d bytes and flush to mp3 file", write);
            lame_mp3_tags_fid(lame, mp3);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        
        @catch (NSException *exception) {
            // NSLog(@"%@", [exception description]);
            if (fail) {
                fail([exception description]);
            }
        }
        
        @finally {
            
            // NSLog(@"convert mp3 finish!!! %@", outPath);
            
            if (isDelete) {
                
                NSError *error;
                [fm removeItemAtPath:sourcePath error:&error];
                if (error == nil)
                {
                    // NSLog(@"删除源文件成功");
                }
            }
            
            if (success) {
                success(outPath);
            }
        }
    });
}

/**
 录音完成的调用
 */
- (void)sendEndRecord {
    self.stopRecord = YES;
}


@end
