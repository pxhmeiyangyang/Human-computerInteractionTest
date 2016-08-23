//
//  NSObject+Rect.m
//  UStudy
//
//  Created by pxh on 16/4/14.
//  Copyright © 2016年 上海云之声. All rights reserved.
//

#import "NSObject+Rect.h"

@implementation NSObject(Rect)


float xRatio(){
    return kScreenWidth / DEFAULE_WIDTH;
}
float yRatio(){
    return kScreenHeight / DEFAULE_HEIGHT;
}

CGFloat AutoWidthFloat(CGFloat len){
    return len * xRatio();
}
CGFloat AutoHeightFloat(CGFloat len){
    return len * yRatio();
}

@end
