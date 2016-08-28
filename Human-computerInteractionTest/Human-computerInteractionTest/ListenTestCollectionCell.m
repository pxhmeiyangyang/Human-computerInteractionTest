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
#import "Waver.h"
typedef NS_ENUM(NSInteger,controlShowType) {
    ControlshowAll,
    ControlHiddenAll,
    ControlShowImage
};

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

@property (nonatomic, weak) Waver *wave;

@end

@implementation ListenTestCollectionCell

-(void)theLayoutSubViews{
    _showScrollView.backgroundColor                = YZH_BLUE;
    _showBgView.backgroundColor                    = YZH_ORCHID;
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
    _mp3Player = [MP3Player sharedInstancePlayer];
    _mp3Player.delegate = self;
    //音频地址
    NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_exam" ofType:@"mp3"];
    [_mp3Player playWithFile:mp3Path];
    [_mp3Player play];
    [self controlViewShow:ControlHiddenAll];
    [self theLayoutSubViews];
    [self addWaver];
}


-(void)resetData{
    _engine = [EngineManager sharedManager];
    _engine.delegate = self;
    [_engine setOralText:@"good moring"];
    _soundCount = 0;
    _countDownTime = 10.0;
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

-(void)controlViewShow:(controlShowType)type{
    switch (type) {
        case ControlshowAll:
            [_soundControlView setHidden:NO];
            [_soundImageView setHidden:NO];
            _showScrollViewBottom.constant = CGRectGetHeight(_soundImageView.frame) + CGRectGetHeight(_soundControlView.frame);
            break;
        case ControlHiddenAll:
            [_soundControlView setHidden:YES];
            [_soundImageView setHidden:YES];
            _showScrollViewBottom.constant = 0;
            break;
        case ControlShowImage:
            [_soundControlView setHidden:NO];
            [_soundImageView setHidden:YES];
            _showScrollViewBottom.constant = CGRectGetHeight(_soundControlView.frame);
            break;
        default:
            break;
    }
}

- (void)addWaver{
    Waver * waver = [[Waver alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_soundImageView.frame) - 50, kScreenWidth - 0, 50)];
    self.wave = waver;
    [self.wave setHidden:YES];
    waver.backgroundColor = [UIColor orangeColor];
    [self.soundImageView addSubview:waver];
//    __weak ListenTestCollectionCell* weakSelf = self;
    waver.waverLevelCallback = ^(Waver * waver) {

    };
//    self.autoresizesSubviews = YES;
//    waver.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
}

#pragma mark - MP3PlayerDelegate
-(void)playFinished:(NSError *)error{
    _soundCount ++;
    switch (_soundCount) {
        case 1:
        {
            [self controlViewShow:ControlshowAll];
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            self.soundTitle.text = @"正在播放原音";
            __weak ListenTestCollectionCell *weakSelf = self;
            if ([_mp3Player play]) {
                _mp3Player.playPorgressBlock = ^(CGFloat progress){
                    NSLog(@"播放进度1：%.4f",progress);
                    weakSelf.soundProgress.progress = progress;
                };
            }
            [_soundImage startAnimating];
        }
            break;
        case 2:
        {
            [self controlViewShow:ControlshowAll];
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"38miao" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            self.soundTitle.text = @"正在播放原音";
            __weak ListenTestCollectionCell *weakSelf = self;
            if ([_mp3Player play]) {
                _mp3Player.playPorgressBlock = ^(CGFloat progress){
                    NSLog(@"播放进度2：%.4f",progress);
                    weakSelf.soundProgress.progress = progress;
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
    NSLog(@"正在计时");
    [_soundImage setHidden:YES];
    if (_frontCountDownTime < _countDownTime) {
        if (_frontCountDownTime == 0) {
            [self controlViewShow:ControlShowImage];
        }
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
        [self controlViewShow:ControlshowAll];
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
    NSLog(@"正在计时");
    if (_frontCountDownTime < _countDownTime) {
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
        [self controlViewShow:ControlHiddenAll];
        //提示停止录音
        [self stopRecording];//停止录音函数
        NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"end_audio" ofType:@"mp3"];
        [_mp3Player playWithFile:mp3Path];
        [_mp3Player play];
    }
}

-(void)starRecording{
    [self.wave setHidden:NO];
    [_engine startRecognize];
}
-(void)stopRecording{
    [_engine stopRecognize];
    [self.wave setHidden:YES];
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
    self.wave.level = volume / 100.0;
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
    _timer     = nil;
    _engine    = nil;
    [_mp3Player stop];
    NSLog(@"Lisencell dealloc");
}

@end
