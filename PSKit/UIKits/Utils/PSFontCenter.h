//
//  PSFontCenter.h
//  PSKit
//
//  Created by PoiSon on 15/11/25.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PSKit/convenientmacros.h>

@protocol PSFontObserver;

typedef NS_ENUM(NSInteger, PSFontLevel) {
    PSEnumOption(PSFontLevelSystem, 0, "字体跟随系统"),
    PSEnumOption(PSFontLevelSmall, 1, "字体小"),
    PSEnumOption(PSFontLevelMedium, 2, "标准字体"),
    PSEnumOption(PSFontLevelLarge, 3, "字体大"),
    PSEnumOption(PSFontLevelExtralLarge, 4, "字体加大"),
    PSEnumOption(PSFontLevelExtralExtralLarge, 5, "字体加加大")
};

/**
 *  字体管理中心
 */
@interface PSFontCenter : NSObject
+ (instancetype)center;

@property (nonatomic, assign) BOOL showLog;/**< 是否输出调试信息 */
@property (nonatomic, readonly) NSString *currentFontName;/**< 当前字体 */
@property (nonatomic, readonly) PSFontLevel currentFontLevel;/**< 当前字体等级 */

#pragma mark - 全局调整字体
- (void)changeFontLevel:(PSFontLevel)newLevel;/**< 调整字体等级 */
- (void)changeFontName:(NSString *)fontName;/**< 调整字体 */
- (void)changeFontLevel:(PSFontLevel)newLevel withFontName:(NSString *)fontName;/**< 调整字体与大小 */

#pragma mark - 调整字体相关方法
- (CGFloat)fontSizeAfterAdjust:(CGFloat)originalSize;/**< 获取适配后的字体大小 */
- (UIFont *)fontAfterAdjust:(UIFont *)originalFont;/**< 获取适配后的字体 */
- (UIFont *)fontWithSize:(CGFloat)fontSize;/**< 获取适配后的字体 */

#pragma mark - 注册与应用主题
- (void)registerObserver:(id<PSFontObserver>)observer;/**< 注册字体观察者 */
- (void)applyThemeToObserver:(id<PSFontObserver>)observer;/**< 手动应用主题到该观察者 */
- (void)autoRegisterClass:(Class)aClass beforeExecuting:(SEL)registeSEL applybeforeExecuting:(SEL)applySEL;/**< 自动将该类型【及子类】下所有实例【已实现协议】自动注册至字体中心，在执行${registeSEL}之前，自动注册进字体中心，在执行${applySEL}之前，自动应用字体 */
@end

@protocol PSFontObserver <NSObject>
- (void)loadFont:(PSFontCenter *)center;/**< 加载字体 */
@end