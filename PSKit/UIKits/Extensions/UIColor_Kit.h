//
//  UIColor+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RgbHex2UIColor(r, g, b)                 [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RgbHex2UIColorWithAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

NS_ASSUME_NONNULL_BEGIN
@interface UIColor (Kit)
+ (UIColor *)ps_randomColor;/**< 随机颜色 */

+ (UIColor *)ps_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;/**< 直接输入int，该方法会执行red/255.0f */

+ (UIColor *)ps_colorWithHex:(int64_t)hexValue alpha:(CGFloat)alpha;/**< 0xFFFFFF 6位16进制颜色 + 透明度 */
+ (UIColor *)ps_colorWithHex:(int64_t)hexValue;/**< 0xFFFFFFFF 8位16进制，32位2进制。使用64位int是防止以后扩展 */
- (int64_t)ps_hexValue;// 0xFFFFFFFF color的二进制，ARGB，32位
- (NSString *)ps_hexString;//返回类似 @"0xFFFFFFFF" 这样的字符串

- (UIColor *)ps_setAlpha:(CGFloat)alpha;/**< 不改变颜色值，改变透明度 */
- (UIColor *)ps_reverseColor;/**< 反色 */
- (void)ps_getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha;/**< 将颜色分解成ARGB */
@end

@interface UIColor (PSColorFormString)
/**
 *  将符合规则的字符串解析成UIColor
 *  @"0.1"               -->   [UIColor colorWithWhite:0.1 alpha:1];
 *  @"0.1, 0.2"          -->   [UIColor colorWithWhite:0.1 alpha:0.2];
 *  @"106, 100, 20"      -->   [UIColor colorWithRed:106/255.0f green:100/255.0f blue:20/255.0f alpha:1];
 *  @"100, 20, 60, 0.7"  -->   [UIColor colorWithRed:100/255.0f green:20/255.0f blue:60/255.0f alpha:0.7];
 *  @"#FFFFFF"           -->   [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
 *  @"#FFFFFFFF"         -->   [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:255/255.0f];
 */
+ (UIColor *)ps_colorFromString:(NSString *)colorString;
@end
NS_ASSUME_NONNULL_END