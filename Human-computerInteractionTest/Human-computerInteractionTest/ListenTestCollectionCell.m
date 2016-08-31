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
#import "QuestionDetail.h"
#import "MJExtension.h"
#define FolderPath [[NSBundle mainBundle]pathForResource:@"media" ofType:@""]

typedef NS_ENUM(NSInteger,controlShowType) {
    ControlshowAll,
    ControlHiddenAll,
    ControlShowImage
};

@interface ListenTestCollectionCell()<MP3PlayerDelegate,EngineManagerDelegate>
{
    NSInteger _soundCount;
    NSTimer* _timer;
    CGFloat _frontCountDownTime;
    EngineManager* _engine;
    BOOL _isNext;
    NSInteger _waitTime;
    NSInteger _timeOut;
    NSInteger _questionTwoRecorder;
}

@property(nonatomic,strong)MP3Player* mp3Player;

@property (nonatomic, weak) Waver *wave;

@property(nonatomic,strong)NSMutableArray* questionTwoArray;
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
    [self controlViewShow:ControlHiddenAll];
    [self theLayoutSubViews];
    [self addWaver];
}

-(void)resetData{
    _engine = [EngineManager sharedManager];
    _engine.delegate = self;
    _soundCount = 0;
    _frontCountDownTime = 0.0;
    _isNext = NO;
    _questionTwoArray = [NSMutableArray array];
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
    return _paperModel.paper.paperName;
}

-(void)controlViewShow:(controlShowType)type{
    switch (type) {
        case ControlshowAll:
            [_soundControlView setHidden:NO];
            [_soundImageView setHidden:NO];
            [_soundImage setHighlighted:NO];
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
    waver.waverLevelCallback = ^(Waver * waver) {

    };    
}

-(void)setPaperModel:(PaperModel *)paperModel{
    _paperModel = paperModel;
    if (self.tag == 0) {
        [self setReadQuestionInfomation:paperModel];
    }else if (self.tag > 0 && self.tag < 5){
        [self setInfoAccessQuestionInfomation:paperModel Index:self.tag];
    }else{
    
    }
}

#pragma mark - 重用cell对应不同cell的赋值
-(void)setReadQuestionInfomation:(PaperModel *)paperModel{
    if (_paperModel.paper.readQuestion.titleAudioPath.length > 0) {
        //音频地址
        NSString* path = [NSString stringWithFormat:@"%@%@",FolderPath,_paperModel.paper.readQuestion.titleAudioPath];
        [_mp3Player playWithFile:path];
        [_mp3Player play];
    }
    if (paperModel.paper.readQuestion.title.length > 0) {
        _titleLabel.text = paperModel.paper.readQuestion.title;
    }
    if (paperModel.paper.readQuestion.descContent.length > 0) {
        _tipLabel.text = paperModel.paper.readQuestion.descContent;
    }
    if (paperModel.paper.readQuestion.content.length > 0) {
        _contentLabel.text = paperModel.paper.readQuestion.content;
    }
    if (paperModel.paper.readQuestion.waitTimeMillseconds > 0) {
        _waitTime = paperModel.paper.readQuestion.waitTimeMillseconds / 1000;
    }
    if (paperModel.paper.readQuestion.timoutMillseconds > 0) {
        _timeOut = paperModel.paper.readQuestion.timoutMillseconds / 1000;
    }

}
-(void)setInfoAccessQuestionInfomation:(PaperModel *)paperModel Index:(NSInteger)index{
    if (paperModel.paper.infoAccessQuestion.title.length > 0) {
        _titleLabel.text = paperModel.paper.infoAccessQuestion.title;
    }
    NSString* content = @"";
    Infoaccessquestionparts* part;
    NSArray* questionDetails;
    switch (index) {
        case 1:
            if (_paperModel.paper.infoAccessQuestion.titleAudioPath.length > 0) {
                //音频地址
                NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,_paperModel.paper.infoAccessQuestion.titleAudioPath];
                [_mp3Player playWithFile:path];
                [_mp3Player play];
            }
            part = paperModel.paper.infoAccessQuestion.infoAccessQuestionParts[0];
            questionDetails = part.questionDetails[0];
            break;
        case 2:
            part = paperModel.paper.infoAccessQuestion.infoAccessQuestionParts[0];
            questionDetails = part.questionDetails[1];
            _soundCount = 3;
            break;
        case 3:
            part = paperModel.paper.infoAccessQuestion.infoAccessQuestionParts[0];
            questionDetails = part.questionDetails[2];
            _soundCount = 3;
            break;
        case 4:
            part = paperModel.paper.infoAccessQuestion.infoAccessQuestionParts[1];
            questionDetails = part.questionDetails[0];
            _soundCount = 3;
            break;
        default:
            break;
    }

    for (id question in questionDetails) {
        QuestionDetail* detail = [QuestionDetail mj_objectWithKeyValues:question];
        NSString* string = [NSString stringWithFormat:@"%@\n%@",detail.question,detail.option.optionContent];
        content = [content stringByAppendingFormat:@"%@\n",string];
        [_questionTwoArray addObject:detail];
    }
    if (content.length > 0) {
        _contentLabel.text = content;
    }
    if (part.title.length > 0 && part.descContent.length > 0) {
        QuestionDetail* detail = _questionTwoArray[0];
        _waitTime = detail.waitTimeMillseconds / 1000;
        if (detail.descContent.length > 0) {
            _tipLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",part.title,part.descContent,detail.descContent];
        }
    }
    if (index > 1 && index < 5) {
        [self questionTwo];
    }
}
#pragma mark - MP3PlayerDelegate
-(void)playFinished:(NSError *)error{
    _soundCount ++;
    if (self.tag == 0) {
        [self questionOne];
    }else if(self.tag > 0){
        [self questionTwo];
    }
}
-(void)questionOne{
    switch (_soundCount) {
        case 1:
        {
            [self controlViewShow:ControlshowAll];
            NSString* path = [NSString stringWithFormat:@"%@%@",FolderPath,_paperModel.paper.readQuestion.descAudioPath];
            [_mp3Player playWithFile:path];
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
            NSString* path = [NSString stringWithFormat:@"%@%@",FolderPath,_paperModel.paper.readQuestion.contentAudioPath];
            [_mp3Player playWithFile:path];
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
    if (_frontCountDownTime < _waitTime ) {
        if (_frontCountDownTime == 0) {
            [self controlViewShow:ControlShowImage];
        }
        _frontCountDownTime ++;
        int ratio = (int)(_waitTime - _frontCountDownTime);
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
        _soundProgress.progress = _frontCountDownTime / _waitTime;
    }else{
        [self controlViewShow:ControlshowAll];
        [_timer invalidate];
        _frontCountDownTime = 0.0;
        //提示开始录音
        NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_audio" ofType:@"mp3"];
        [_mp3Player playWithFile:mp3Path];
        [_mp3Player play];
        //开始录音
        [self starRecordingWithOralText:_paperModel.paper.readQuestion.content];
    }
}
-(void)soundWait:(NSTimer* )timer{
    NSLog(@"正在计时");
    if (_frontCountDownTime < _timeOut) {
        _frontCountDownTime ++;
        int ratio = (int)(_timeOut - _frontCountDownTime);
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
        _soundProgress.progress = _frontCountDownTime / _timeOut;
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
-(void)questionTwo{
    Infoaccessquestionparts* part = _paperModel.paper.infoAccessQuestion.infoAccessQuestionParts[0];
    QuestionDetail* detail1 = _questionTwoArray[0];
    QuestionDetail* detail2 = _questionTwoArray[1];
    switch (_soundCount) {
        case 1:
        {
            [self controlViewShow:ControlshowAll];
            NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,part.titleAudioPath];
            [_mp3Player playWithFile:path];
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
            NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,part.descAudioPath];
            [_mp3Player playWithFile:path];
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
            [self controlViewShow:ControlshowAll];
            NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,detail1.descAudioPath];
            [_mp3Player playWithFile:path];
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
        case 4:
        {
            [_soundImage setHidden:YES];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(questionTwocountDown  :) userInfo:nil repeats:YES];
            _soundProgress.progress = 1.0;
        }
            break;
        case 5:
        {
            [self controlViewShow:ControlshowAll];
            NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,detail1.questionAudioPath];
            [_mp3Player playWithFile:path];
            _mp3Player.audioPlayer.numberOfLoops = detail1.questionAudioRepeatTimes - 1;
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
        case 6:
        {
            [self controlViewShow:ControlshowAll];
            [_timer invalidate];
            _frontCountDownTime = 0.0;
            //提示开始录音
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_audio" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            [_mp3Player play];
        }
            break;
        case 7:{
            //开始录音
            [_soundImage stopAnimating];
            [self starRecordingWithOralText:detail1.jsgf];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(questionTwosoundWait:) userInfo:nil repeats:YES];
            _soundProgress.progress = 1.0;
        }
            break;
        case 8:
        {
            [self controlViewShow:ControlshowAll];
            NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,detail2.questionAudioPath];
            [_mp3Player playWithFile:path];
            _mp3Player.audioPlayer.numberOfLoops = detail2.questionAudioRepeatTimes - 1;
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
        case 9:
        {
            [self controlViewShow:ControlshowAll];
            [_timer invalidate];
            _frontCountDownTime = 0.0;
            //提示开始录音
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"start_audio" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            [_mp3Player play];
        }
            break;
        case 10:
        {
            //开始录音
            [_soundImage stopAnimating];
            [self starRecordingWithOralText:detail2.jsgf];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(questionTwosoundWait:) userInfo:nil repeats:YES];
            _soundProgress.progress = 1.0;
            _questionTwoRecorder ++;
        }
            break;
        case 11:
        {
            [self gotoNextSubject];
        }
            break;
        default:
            break;
    }
}
-(void)questionTwocountDown:(NSTimer* )timer{
    if (_frontCountDownTime < _waitTime ) {
        if (_frontCountDownTime == 0) {
            [self controlViewShow:ControlShowImage];
        }
        _frontCountDownTime ++;
        int ratio = (int)(_waitTime - _frontCountDownTime);
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
        _soundProgress.progress = _frontCountDownTime / _waitTime;
    }else{
        [_soundImage setHidden:NO];
        QuestionDetail* detail = _questionTwoArray[0];
        [_timer invalidate];
        _frontCountDownTime = 0.0;
        [self controlViewShow:ControlshowAll];
        self.soundProgress.progress = 0;
        NSString* path = [NSString stringWithFormat:@"%@/%@",FolderPath,detail.audioPath];
        [_mp3Player playWithFile:path];
        _mp3Player.audioPlayer.numberOfLoops = detail.audioRepeatTimes - 1;
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
}
-(void)questionTwosoundWait:(NSTimer* )timer{
    QuestionDetail* detail = _questionTwoArray[_questionTwoRecorder];
    CGFloat timeOut = detail.timeoutMillseconds / 1000;
    if (_frontCountDownTime < timeOut) {
        _frontCountDownTime ++;
        int ratio = (int)(timeOut - _frontCountDownTime);
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
        _soundProgress.progress = _frontCountDownTime / timeOut;
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

-(void)starRecordingWithOralText:(NSString* )text{
    [_engine setOralText:text];
    [_engine startRecognize];
    [self.wave setHidden:NO];
    [_soundImage setImage:[UIImage imageNamed:@"05_mic"]];
    _soundProgress.progress = .0;
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
    if (self.tag > 0) {
        if (_questionTwoRecorder == 1) {
            [self gotoNextSubject];
        }
    }else{
        [self gotoNextSubject];
    }
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
