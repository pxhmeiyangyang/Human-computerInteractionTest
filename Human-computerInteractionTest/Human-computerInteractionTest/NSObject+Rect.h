//
//  NSObject+Rect.h
//  UStudy
//
//  Created by pxh on 16/4/14.
//  Copyright © 2016年 上海云之声. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject(Rect)


#define DEFAULE_WIDTH                 1080.0
#define DEFAULE_HEIGHT                1920.0

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

extern float xRatio();
extern float yRatio();

extern CGFloat AutoWidthFloat(CGFloat len);
extern CGFloat AutoHeightFloat(CGFloat len);

@end
