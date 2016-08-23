//
//  ViewController.h
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingAloudVC : BaseVC

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

