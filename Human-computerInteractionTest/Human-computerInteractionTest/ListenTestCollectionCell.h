//
//  ListenTestCollectionCell.h
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/25.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListenTestCollectionCell : UICollectionViewCell

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

@end
