//
//  MP3Player.h
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^PlayPorgressBlock)(CGFloat progress);

@protocol MP3PlayerDelegate <NSObject>

-(void)playFinished:(NSError *)error;

@end

@interface MP3Player : NSObject<AVAudioPlayerDelegate>
{
    NSString *filePath;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, assign) id<MP3PlayerDelegate> delegate;

@property(nonatomic,copy)PlayPorgressBlock playPorgressBlock;

//- (id)initWithPath:(NSString *)path;

+(instancetype)sharedInstancePlayer;

- (BOOL)play;
- (void)stop;

-(void)playWithFile:(NSString *)path;

-(void)playWithUrl:(NSString* )url;

@end


