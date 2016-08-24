//
//  ViewController.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "ReadingAloudVC.h"
#import "MP3Player.h"
@interface ReadingAloudVC ()<MP3PlayerDelegate>
{
    NSInteger _soundCount;
}
@property (weak, nonatomic) IBOutlet UIScrollView *showScrollView;
@property (weak, nonatomic) IBOutlet UIView *showBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showBgViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *soundControlView;
@property (weak, nonatomic) IBOutlet UILabel *soundTitle;
@property (weak, nonatomic) IBOutlet UIImageView *soundImage;
@property (weak, nonatomic) IBOutlet UIProgressView *soundProgress;


@property(nonatomic,strong)MP3Player* mp3Player;

@end

@implementation ReadingAloudVC

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubViews];
}
-(void)layoutSubViews{
    _showScrollView.backgroundColor              = YZH_BLUE;
    _showScrollView.showsVerticalScrollIndicator = NO;
    _showBgView.backgroundColor                  = YZH_GREEN;
    _contentLabel.backgroundColor                = [UIColor redColor];
    _showBgViewHeight.constant                   = CGRectGetMaxY(_contentLabel.frame) + CGRectGetHeight(_contentLabel.frame);
    UIImage* trackImage                          = [UIColor getImageFromColor:[UIColor whiteColor] frame:CGRectMake(0, 0, CGRectGetWidth(_soundProgress.frame), CGRectGetHeight(_soundProgress.frame))];
    [_soundProgress setTrackImage:trackImage];
    [_soundProgress setBackgroundColor:[UIColor clearColor]];
    [_soundProgress setProgressTintColor:YZH_BLUE];
    _soundProgress.transform                     = CGAffineTransformMakeScale(1.0f, 4.0f);
    [_showScrollView setContentSize:_showBgView.frame.size];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self resetData];
    [self setImageViewAnimation];
    _mp3Player = [MP3Player sharedInstancePlayer];
    _mp3Player.delegate = self;
    //音频地址
    NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"tixing" ofType:@"mp3"];
    [_mp3Player playWithFile:mp3Path];
    [_mp3Player play];
    [_soundControlView setHidden:YES];
}

-(void)resetData{
    _soundCount = 0;
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
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            __block ReadingAloudVC* blockSelf = self;
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
            NSString* mp3Path = [[NSBundle mainBundle]pathForResource:@"38miao" ofType:@"mp3"];
            [_mp3Player playWithFile:mp3Path];
            __block ReadingAloudVC* blockSelf = self;
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
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end