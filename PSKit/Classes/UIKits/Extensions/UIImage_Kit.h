//
//  UIImage+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    PSGradientTopToBottom = 0,/**< 从上到小 */
    PSGradientLeftToRight = 1,/**< 从左到右 */
    PSGradientUpleftTolowRight = 2,/**< 左上到右下 */
    PSGradientUprightTolowLeft = 3/**< 右上到左下 */
}PSGradientType;

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (Kit)
- (instancetype)ps_imageResized;/**< 将图片拉申后返回(上下左右3.5f) */
+ (instancetype)ps_imageWithColor:(UIColor *)color;/**< 返回1*1像素的色块 */
+ (instancetype)ps_imageNamed:(NSString *)name withTintColor:(UIColor *)color;/**< 将图片中的不透明部份转换成目标颜色(缓存) */
+ (instancetype)ps_imageWithImage:(UIImage *)image tintColor:(UIColor *)color;/**< 将图片中的不透明部份转换成目标颜色(不缓存) */

/**
 *  绘制渐变色图片
 *
 *  @param size         图片大小
 *  @param fromColor    渐变开始颜色
 *  @param toColor      渐变结束颜色
 *  @param gradientType 渐变方式
 */
+ (instancetype)ps_imageWithSize:(CGSize)size fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor byGradientType:(PSGradientType)gradientType;
@end
NS_ASSUME_NONNULL_END