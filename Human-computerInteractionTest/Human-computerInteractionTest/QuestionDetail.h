//
//  QuestionDetail.h
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/29.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Option;
@interface QuestionDetail : NSObject

@property (nonatomic, copy) NSString *questionAudioPath;

@property (nonatomic, assign) NSInteger timeoutMillseconds;

@property (nonatomic, assign) NSInteger partId;

@property (nonatomic, assign) NSInteger audioRepeatTimes;

@property (nonatomic, assign) BOOL hasOption;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, copy) NSString *descAudioPath;

@property (nonatomic, strong) Option *option;

@property (nonatomic, copy) NSString *jsgf;

@property (nonatomic, assign) NSInteger group;

@property (nonatomic, assign) NSInteger waitTimeMillseconds;

@property (nonatomic, copy) NSString *descContent;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, assign) NSInteger infoAccessDetailId;

@property (nonatomic, assign) NSInteger questionAudioRepeatTimes;

@property (nonatomic, copy) NSString *audioPath;

@end
@interface Option : NSObject

@property (nonatomic, copy) NSString *correct;

@property (nonatomic, copy) NSString *optionContent;

@property (nonatomic, assign) NSInteger optionId;

@property (nonatomic, assign) NSInteger infoAccessDetailId;

@end

