//
//  ListenTestCollectionCell.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/25.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "ListenTestCollectionCell.h"
#import "MP3Player.h"
#import "EngineManager.h"
@interface ListenTestCollectionCell()<MP3PlayerDelegate,EngineManagerDelegate>
{
    NSInteger _soundCount;
    NSTimer* _timer;
    CGFloat _countDownTime;
    CGFloat _frontCountDownTime;
    EngineManager* _engine;
    BOOL _isNext;
}

@property(nonatomic,strong)MP3Player* mp3Player;

@end

@implementation ListenTestCollectionCell

-(void)layoutSubViews{
    [super layoutSubviews];
    _showScrollView.backgroundColor                = YZH_BLUE;
    _showBgView.backgroundColor                    = YZH_GREEN;
    _contentLabel.backgroundColor                  = [UIColor redColor];
    _showBgViewHeight.constant                     = CGRectGetMaxY(_contentLabel.frame) + CGRectGetHeight(_contentLabel.frame);
    UIImage* trackImage                            = [UIColor getImageFromColor:[UIColor whiteColor] frame:CGRectMake(0, 0, CGRectGetWidth(_soundProgress.frame), CGRectGetHeight(_soundProgress.frame))];
    [_soundProgress setTrackImage:trackImage];
    [_soundProgress setBackgroundColor:[UIColor clearColor]];
    [_soundProgress setProgressTintColor:YZH_BLUE];
    _soundProgress.transform                       = CGAffineTransformMakeScale(1.0f, 4.0f);
    [_showScrollView setContentSize:_showBgView.frame.size];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self resetData];
    [self setImageViewAnimation];
//    _showBgView.backgroundColor = [UIColor orangeColor];
    _mp3Player = [MP3Player sharedInstancePlayer];
    _mp3Player.delegate = self;
    //音频地址
    NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_exam" ofType:@"mp3"];
    [_mp3Player playWithFile:mp3Path];
    [_mp3Player play];
    [_soundControlView setHidden:YES];
//    [self setSoundControlViewHidden:YES];
}

//-(void)setSoundControlViewHidden:(BOOL)hidden{
//    [_soundControlView setHidden:hidden];
//    CGFloat controlHeight = CGRectGetHeight(_showBgView.frame);
//    BOOL ratio = controlHeight > kScreenHeight - 44 - CGRectGetHeight(_soundControlView.frame);
//    if (hidden) {
//        if (ratio) {
//            [_showScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }else{
//        if (ratio) {
//            [_showScrollView setContentOffset:CGPointMake(0, CGRectGetHeight(_soundControlView.frame)) animated:YES];
//        }
//    }
//}

-(void)resetData{
    _engine = [EngineManager sharedManager];
    _engine.delegate = self;
    [_engine setOralText:@"good moring"];
    _soundCount = 0;
    _countDownTime = 50.0;
    _frontCountDownTime = 0.0;
    _isNext = NO;
}

-(void)setImageViewAnimation{
    NSArray* images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"play01"],
                       [UIImage imageNamed:@"play02"],
                       [UIImage imageNamed:@"play03"],nil];
    _soundImage.animationImages = images;
    _soundImage.animationDuration = 0.9;
    _soundImage.animationRepeatCount = 0;
}

-(NSString *)VCTitle{
    return @"Modul1";
}

#pragma mark - MP3PlayerDelegate
-(void)playFinished:(NSError *)error{
    if (error) {
        
    }else{
        
    }
    _soundCount ++;
    switch (_soundCount) {
        case 1:
        {
            [_soundControlView setHidden:NO];
//            [self setSoundControlViewHidden:NO];
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            __block ListenTestCollectionCell* blockSelf = self;
            if ([_mp3Player play]) {
                _mp3Player.playPorgressBlock = ^(CGFloat progress){
                    NSLog(@"播放进度：%.4f",progress);
                    blockSelf.soundTitle.text = @"正在播放原音";
                    blockSelf.soundProgress.progress = progress;
                };
            }
            [_soundImage startAnimating];
        }
            break;
        case 2:
        {
            [_soundControlView setHidden:NO];
//            [self setSoundControlViewHidden:NO];
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"38miao" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            __block ListenTestCollectionCell* blockSelf = self;
            if ([_mp3Player play]) {
                _mp3Player.playPorgressBlock = ^(CGFloat progress){
                    NSLog(@"播放进度：%.4f",progress);
                    blockSelf.soundTitle.text = @"正在播放原音";
                    blockSelf.soundProgress.progress = progress;
                };
            }
            [_soundImage startAnimating];
        }
            break;
        case 3:
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
            
            _soundProgress.progress = 1.0;
        }
            break;
        case 4:
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(soundWait:) userInfo:nil repeats:YES];
            [_soundImage stopAnimating];
            [_soundImage setHidden:NO];
            [_soundImage setImage:[UIImage imageNamed:@"05_mic"]];
        }
            break;
        case 5:
        {
            [self gotoNextSubject];
        }
            break;
        default:
            break;
    }
}

-(void)countDown:(NSTimer* )timer{
    [_soundImage setHidden:YES];
    if (_frontCountDownTime < 50) {
        _frontCountDownTime ++;
        int ratio = (int)(_countDownTime - _frontCountDownTime);
        NSString* str = [NSString stringWithFormat:@"准备朗读（倒计时%d秒）",ratio];
        NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange rang;
        if (ratio > 9) {
            rang = NSMakeRange(8, 2);
        }else{
            rang = NSMakeRange(8, 1);
        }
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:rang];
        [_soundTitle setAttributedText:attriStr];
        _soundProgress.progress = _frontCountDownTime / _countDownTime;
    }else{
        [_timer invalidate];
        _frontCountDownTime = 0.0;
        //提示开始录音
        NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_audio" ofType:@"mp3"];
        [_mp3Player playWithFile:mp3Path];
        [_mp3Player play];
        //开始录音
        [self starRecording];
    }
}
-(void)soundWait:(NSTimer* )timer{
    if (_frontCountDownTime < 50) {
        _frontCountDownTime ++;
        int ratio = (int)(_countDownTime - _frontCountDownTime);
        NSString* str = [NSString stringWithFormat:@"请开始录音（倒计时%d秒）",ratio];
        NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range;
        if (ratio > 9) {
            range = NSMakeRange(9, 2);
        }else{
            range = NSMakeRange(9, 1);
        }
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        [_soundTitle setAttributedText:attriStr];
        _soundProgress.progress = _frontCountDownTime / _countDownTime;
    }else{
        [_timer invalidate];
        [_soundControlView setHidden:YES];
//        [self setSoundControlViewHidden:YES];
        //提示停止录音
        [self stopRecording];//停止录音函数
        NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"end_audio" ofType:@"mp3"];
        [_mp3Player playWithFile:mp3Path];
        [_mp3Player play];
    
       
    }
}

-(void)starRecording{
    [_engine startRecognize];
}
-(void)stopRecording{
    [_engine stopRecognize];
}
-(void)gotoNextSubject{
    if (_isNext) {
        //结束录音跳转下一个界面
        if (_nextItemBlock) {
            _nextItemBlock();
        }
        
    }else{
        _isNext = YES;
    }
}
#pragma mark - enginemagedelagete
- (void)onBeginOral{
}

- (void)onStopOral{
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast{
    NSLog(@"record result:%@",result);
}

- (void)onEndOral:(NSError *)error{
    [self gotoNextSubject];
}

- (void)onVADTimeout{
}

- (void)onUpdateVolume:(int)volume{
}

- (void)onRecordingBuffer:(NSData *)recordingData{
}

- (void)oralEngineDidInit:(NSError *)error{
}

- (void)audioFileDidRecord:(NSString *)url{
}

- (void)recorderTimeTooShort:(BOOL)isShort{
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

@end
