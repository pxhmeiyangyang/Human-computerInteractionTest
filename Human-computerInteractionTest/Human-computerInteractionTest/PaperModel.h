//
//  PaperModel.h
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/29.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Paper,Infodescquestion,Infodescquestionparts,Details,Infoaccessquestion,Infoaccessquestionparts,Readquestion;
@interface PaperModel : NSObject

@property (nonatomic, strong) Paper *paper;

@property (nonatomic, assign) NSInteger code;

@end

@interface Paper : NSObject

@property (nonatomic, copy) NSString *resourceUrl;

@property (nonatomic, assign) NSInteger questionCount;

@property (nonatomic, strong) Readquestion *readQuestion;

@property (nonatomic, assign) NSInteger paperId;

@property (nonatomic, strong) Infodescquestion *infoDescQuestion;

@property (nonatomic, copy) NSString *paperName;

@property (nonatomic, strong) Infoaccessquestion *infoAccessQuestion;

@end

@interface Infodescquestion : NSObject

@property (nonatomic, copy) NSString *titleAudioPath;

@property (nonatomic, strong) NSArray<Infodescquestionparts *> *infoDescQuestionParts;

@property (nonatomic, assign) NSInteger infoDescId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger totalScore;

@end

@interface Infodescquestionparts : NSObject

@property (nonatomic, assign) NSInteger partId;

@property (nonatomic, assign) NSInteger questionCount;

@property (nonatomic, assign) NSInteger scorePerQuestion;

@property (nonatomic, assign) NSInteger audioRepeatTimes;

@property (nonatomic, strong) NSArray<Details *> *details;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, copy) NSString *titleAudioPath;

@property (nonatomic, copy) NSString *descContent;

@property (nonatomic, copy) NSString *descAudioPath;

@property (nonatomic, copy) NSString *audioPath;

@end

@interface Details : NSObject

@property (nonatomic, copy) NSString *descAudioPath;

@property (nonatomic, assign) NSInteger subWaitTimeMillseconds;

@property (nonatomic, assign) NSInteger timoutMillseconds;

@property (nonatomic, copy) NSString *jsgf;

@property (nonatomic, copy) NSString *subDescAudioPath;

@property (nonatomic, assign) NSInteger waitTimeMillseconds;

@property (nonatomic, assign) NSInteger detailId;

@property (nonatomic, copy) NSString *descContent;

@property (nonatomic, copy) NSString *subDescContent;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *questionPicPath;

@property (nonatomic, assign) NSInteger audioRepeatTimes;

@end

@interface Infoaccessquestion : NSObject

@property (nonatomic, copy) NSString *titleAudioPath;

@property (nonatomic, assign) NSInteger infoAccessId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, strong) NSArray<Infoaccessquestionparts *> *infoAccessQuestionParts;

@end

@interface Infoaccessquestionparts : NSObject

@property (nonatomic, copy) NSString *audioPath;

@property (nonatomic, assign) NSInteger audioRepeatTimes;

@property (nonatomic, assign) NSInteger partId;

@property (nonatomic, assign) NSInteger questionCount;

@property (nonatomic, strong) NSArray *questionDetails;

@property (nonatomic, copy) NSString *descAudioPath;

@property (nonatomic, copy) NSString *titleAudioPath;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, copy) NSString *descContent;

@property (nonatomic, assign) NSInteger scorePerQuestion;

@property (nonatomic, assign) NSInteger infoAccessId;

@end

@interface Readquestion : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *contentAudioPath;

@property (nonatomic, assign) NSInteger audioRepeatTimes;

@property (nonatomic, assign) NSInteger waitTimeMillseconds;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger readQuestionId;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, copy) NSString *titleAudioPath;

@property (nonatomic, copy) NSString *descContent;

@property (nonatomic, copy) NSString *descAudioPath;

@property (nonatomic, assign) NSInteger timoutMillseconds;

@end

