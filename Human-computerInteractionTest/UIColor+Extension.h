//
//  UIColor+Extension.h
//  UStudy
//
//  Created by pxh on 16/4/8.
//  Copyright © 2016年 上海云之声. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//整个app的相关颜色
#define YZH_BG_COLOR                    [UIColor colorWithHexStr:@"f1f4ef"]

#define YZH_BLUE                    [UIColor colorWithHexStr:@"61bcf9"]

#define YZH_SHALLOW_BLUE            [UIColor colorWithHexStr:@"b9e6ff"]

#define YZH_RED                     [UIColor colorWithHexStr:@"ff7061"]

#define YZH_SHALLOW_RED             [UIColor colorWithHexStr:@"ffd0c8"]

#define YZH_ORCHID                  [UIColor colorWithHexStr:@"36c6bf"]

#define YZH_SHALLOW_ORCHID          [UIColor colorWithHexStr:@"b7f0e9"]

#define YZH_GREEN                   [UIColor colorWithHexStr:@"a0c84a"]

#define YZH_SHALLOW_GREEN           [UIColor colorWithHexStr:@"edf7d5"]

/**
 *  RGB 颜色读取
 */
#undef PXH_RGBA
#define PXH_RGBA_COLOR(R,G,B,A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

#undef PXH_RGB
#define PXH_RGB_COLOR(R,G,B)    [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

/**
 *  从十六进色值中获取颜色
 */
+(UIColor* )colorWithHexStr:(NSString* )color;
/**
 *  从十六进制中获取颜色 并设置alpha值
 */
+(UIColor* )colorWithHexStr:(NSString *)color alpha:(CGFloat )alpha;
/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color;

/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *  @param frame 生成图片的尺寸
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color frame:(CGRect)frame;

@end
