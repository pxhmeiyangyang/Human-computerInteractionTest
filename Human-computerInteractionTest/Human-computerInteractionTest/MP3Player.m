//
//  MP3Player.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "MP3Player.h"

@interface MP3Player()
{
    NSTimer* _sliderTimer;
}
//@property(nonatomic,strong)NSTimer* sliderTimer

@end

static MP3Player* _instancePlayer = nil;

@implementation MP3Player

+(void)initialize{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

//- (id)initWithPath:(NSString *)path{
//    if (self = [super init])
//    {
//        NSURL *recordingURL= [[NSURL alloc] initFileURLWithPath:path];
//        player = [[AVAudioPlayer alloc]initWithContentsOfURL:recordingURL error:nil];
//        [player prepareToPlay];
//    }
//    
//    return self;
//}
+(instancetype)sharedInstancePlayer{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instancePlayer = [[self alloc]init];
    });
    return _instancePlayer;
}

- (BOOL)play{
    NSLog(@"play");
    _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progress:) userInfo:nil repeats:YES];
    return [audioPlayer play];
}

-(void)progress:(NSTimer* )timer{
    CGFloat progressValue = audioPlayer.currentTime / audioPlayer.duration;
    if (_playPorgressBlock) {
        _playPorgressBlock(progressValue);
    }
}

- (void)stop{
    [_sliderTimer invalidate];
    [audioPlayer stop];
}

-(void)playWithFile:(NSString *)path{
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
}

-(void)playWithUrl:(NSString* )url{
    NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_sliderTimer invalidate];
    if (_delegate && [_delegate respondsToSelector:@selector(playFinished:)]) {
        [self.delegate playFinished:nil];
    }
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [_sliderTimer invalidate];
    if (_delegate && [_delegate respondsToSelector:@selector(playFinished:)]) {
        [self.delegate playFinished:error];
    }
}
-(void)dealloc{
    NSLog(@"mp3Player dealloc");
}
@end
