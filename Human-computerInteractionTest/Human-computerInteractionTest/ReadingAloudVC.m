//
//  ViewController.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "ReadingAloudVC.h"
#import "SoundControlView.h"
@interface ReadingAloudVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *showScrollView;
@property (weak, nonatomic) IBOutlet UIView *showBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showBgViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet SoundControlView *soundControlView;

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
    [_showScrollView setContentSize:_showBgView.frame.size];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)VCTitle{
    return @"Modul1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
