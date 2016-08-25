//
//  EngineManager.m
//  AsrOralDemo
//
//  Created by 刘俊 on 15/6/25.
//  Copyright (c) 2015年 yunzhisheng. All rights reserved.
//

#import "EngineManager.h"
#import <AVFoundation/AVFoundation.h>

@interface EngineManager ()

@property(nonatomic,strong)NSDate* startDate;

@end

@implementation EngineManager

@synthesize delegate;

static EngineManager *mEngineManager;

+ (EngineManager *)sharedManager
{
    if(mEngineManager == nil)
    {
        mEngineManager = [[EngineManager alloc]init];
    }
    
    return mEngineManager;
}

-(id)init
{
    if (self = [super init])
    {
        [self recognizerInit];
        
        recogMode = Recognize_REC;  //默认使用录音
        
        stateMachine = [[EngineStateMachine alloc]init];
        [stateMachine reset];
    }
    
    return self;
}

- (NSString *)version
{
    return [USCRecognizer version];
}

-(void)recognizerInit
{
    NSString *sourcePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"tmp_oral_offline.bundle"];
    recognizer = [[USCRecognizer alloc] initWithSource:sourcePath];
    recognizer.delegate = self;
//    [recognizer setVadFrontTimeout:3000 backTimeout:1000];
    recognizer.oralTask = @"B";         //默认B模式
//    [recognizer setOutScoreCoefficient:1.5];
    recognizer.audioType = AudioType_MP3;
//    USLog(@"SDK Version : %@",[USCRecognizer version]);
    
    //设置设备唯一标识
    [self loadRecognizerSettings:recognizer];
    //默认使用麦克风
    [self setRecognizerMode:Recognize_REC];
}

//- (void)setVadFrontTimeout:(double)fontTime backTimeout:(double)backTime{
//    [recognizer setVadFrontTimeout:fontTime backTimeout:backTime];
//}
//- (void)resetVAD{
//    [recognizer setVadFrontTimeout:3000 backTimeout:1000];
//}

-(void)startRecognize
{
    _startDate = [NSDate date];
    if (![stateMachine couldStart])
    {
        return;
    }
    //printf("\n\n\n\n\n\n");
//    USLog(@" - startRecognize - ");
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [session setActive:YES error:nil];
    recordData = nil;
    
    if (recogMode == Recognize_REC)
    {
        [recognizer start];
    }
    else if (recogMode == Recognize_PCM)
    {
        NSString *pcmFilePath = [self pcmFilePath];
        if (pcmFilePath != NULL)
        {
            [recognizer startWithPCM:pcmFilePath];
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"没有PCM文件" code:NO_PCM_FILE userInfo:nil];
            if (delegate != NULL && [delegate respondsToSelector:@selector(onEndOral:)])
            {
                [delegate onEndOral:error];
            }
        }
    }
}

-(void)stopRecognize
{
    if (![stateMachine couldStop])
    {
        return;
    }
    
//    USLog(@" - stopRecognize - ");
    
    NSTimeInterval time = [[NSDate date]timeIntervalSinceDate:_startDate];
    if (time < 0.5) {
        if (delegate != NULL && [delegate respondsToSelector:@selector(recorderTimeTooShort:)])
        {
            [delegate recorderTimeTooShort:YES];
        }
//        [MyCustomAlertView shwoCenterTimerTooShortDuration:2.0];
    }else{
        if (delegate != NULL && [delegate respondsToSelector:@selector(recorderTimeTooShort:)])
        {
            [delegate recorderTimeTooShort:NO];
        }
    }
    
    [recognizer stop];
}

-(void)cancelRecognize
{
    if (![stateMachine couldCancel])
    {
        return;
    }
    
//    USLog(@" - cancelRecognize - ");
    
    [recognizer cancel];
}

-(void)setRecognizerMode:(RecognizeMode)mode
{
//    USLog(@"setRecognizerMode : %lu",(unsigned long)mode);
    recogMode = mode;
}

-(RecognizeMode)getRecognizerMode
{
    return recogMode;
}

-(NSString *)getOralTask
{
    return recognizer.oralTask;
}

-(void)setOralText:(NSString *)text
{
//    USLog(@"setOralText : %@",text);
    
    recognizer.oralText = text;
}

-(void)setOralTask:(NSString *)task
{
//    USLog(@"setOralTask : %@",task);
    recognizer.oralTask = task;
}

-(NSString *)pcmFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:FILE_INPUT_PCM];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return filePath;
    }
    
    return NULL;
}

-(void)writeFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *testPath = [documentsPath stringByAppendingPathComponent:FILE_NAME_RECORDING];
    NSError *error;
    BOOL res=[recordData writeToFile:testPath options:NSDataWritingFileProtectionComplete error:&error];
    if (res)
    {
    }
    else
    {
    }
}

-(void)loadRecognizerSettings:(USCRecognizer *)recog
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths[0];
    NSString *settingPath = [document stringByAppendingPathComponent:@"Setting.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:settingPath])
    {
        NSDictionary *settingDic = [NSDictionary dictionaryWithContentsOfFile:settingPath];
        if (settingDic != NULL && settingDic.count > 0)
        {
            NSString *identifier = settingDic[@"identifier"];
            
            if (identifier != NULL && identifier.length > 0)
            {
                [recog setIdentifier:identifier];
            }
        }
    }
}

#pragma mark
#pragma mark USCRecognizerDelegate

- (void)onBeginOral
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(onBeginOral)])
    {
        [delegate onBeginOral];
    }
}

- (void)onStopOral
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(onStopOral)])
    {
        [delegate onStopOral];
    }
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(onResult:isLast:)])
    {
        [delegate onResult:result isLast:isLast];
    }
}

- (void)onEndOral:(NSError *)error
{    
    //保存录音文件
//    [self writeFile];
    
    [stateMachine reset];
//    if (error) {
//        [self recordingAuthority];
//    }
    if (delegate != NULL && [delegate respondsToSelector:@selector(onEndOral:)])
    {
        [delegate onEndOral:error];
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

- (void)recordingAuthority{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 用户同意获取数据
//            USLog(@"同意...");
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"没有录音权限" message:@"请在“设置-隐私-麦克风”选项中允许xx访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            });
        }
    }];
}

- (void)onUpdateVolume:(int)volume
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(onUpdateVolume:)])
    {
        [delegate onUpdateVolume:volume];
    }
}

- (void)onVADTimeout
{    
    [recognizer stop];
    
    if (delegate != NULL && [delegate respondsToSelector:@selector(onVADTimeout)])
    {
        [delegate onVADTimeout];
    }
}

- (void)onRecordingBuffer:(NSData *)recordingData
{
    if (recordData==nil)
    {
        recordData = [[NSMutableData alloc]init];
    }
    
    if (recordingData!=nil)
    {
        [recordData appendData:recordingData];
    }
    
    if (delegate != NULL && [delegate respondsToSelector:@selector(onRecordingBuffer:)])
    {
        [delegate onRecordingBuffer:recordingData];
    }
}

- (void)oralEngineDidInit:(NSError *)error
{    
    if (delegate != NULL && [delegate respondsToSelector:@selector(oralEngineDidInit:)])
    {
        [delegate oralEngineDidInit:error];
    }
}

- (void)audioFileDidRecord:(NSString *)url
{    
    if (delegate != NULL && [delegate respondsToSelector:@selector(audioFileDidRecord:)])
    {
        [delegate audioFileDidRecord:url];
    }
}

@end
