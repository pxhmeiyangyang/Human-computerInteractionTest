//
//  PaperModel.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/29.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "PaperModel.h"

@implementation PaperModel

@end
@implementation Paper

@end


@implementation Infodescquestion

+ (NSDictionary *)objectClassInArray{
    return @{@"infoDescQuestionParts" : [Infodescquestionparts class]};
}

@end


@implementation Infodescquestionparts

+ (NSDictionary *)objectClassInArray{
    return @{@"details" : [Details class]};
}

@end


@implementation Details

@end


@implementation Infoaccessquestion

+ (NSDictionary *)objectClassInArray{
    return @{@"infoAccessQuestionParts" : [Infoaccessquestionparts class]};
}

@end


@implementation Infoaccessquestionparts

@end


@implementation Readquestion

@end


