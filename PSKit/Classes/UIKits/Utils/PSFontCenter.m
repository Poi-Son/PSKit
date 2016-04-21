//
//  PSFontCenter.m
//  PSKit
//
//  Created by PoiSon on 15/11/25.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFontCenter.h"
#import "PSFoudation.h"
#import "PSAspect.h"

static NSString *PSFontCenterCurrentFontNameKey = @"PS_FONT_CENTER_CURRENT_FONTNAME_KEY";
static NSString *PSFontCenterCurrentFontLevelKey = @"PS_FONT_CENTER_CURRENT_FONTLEVEL_KEY";

@implementation PSFontCenter{
    NSString *_currentFontName;
    PSFontLevel _currentLevel;
    NSHashTable *_observers;
}
- (NSInteger)increasementForLevel:(PSFontLevel)level{
    if (level == PSFontLevelSystem) {
        NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
        if (contentSize == UIContentSizeCategoryExtraSmall || contentSize == UIContentSizeCategorySmall) {
            level = PSFontLevelSmall;
        }else if (contentSize == UIContentSizeCategoryMedium){
            level = PSFontLevelMedium;
        }else if (contentSize == UIContentSizeCategoryLarge){
            level = PSFontLevelLarge;
        }else if (contentSize == UIContentSizeCategoryExtraLarge){
            level = PSFontLevelExtralLarge;
        }else{
            level = PSFontLevelExtralExtralLarge;
        }
    }
    
    switch (level) {
        case PSFontLevelSmall:
            return -2;
        case PSFontLevelMedium:
            return 0;
        case PSFontLevelLarge:
            return 2;
        case PSFontLevelExtralLarge:
            return 4;
        case PSFontLevelExtralExtralLarge:
            return 8;
        default:
            return 0;
    }
}

- (instancetype)_init{
    if (self = [super init]) {
        _observers = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
- (instancetype)init{
    PSAssertFail(@"使用[PSFontCenter center]来获取实例");
    return nil;
}
+ (instancetype)center{
    static PSFontCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PSFontCenter alloc] _init];
    });
    return instance;
}

- (NSString *)currentFontName{
    return _currentFontName ?: ({
        _currentFontName = [[NSUserDefaults standardUserDefaults] ps_objectForKey:PSFontCenterCurrentFontNameKey
                                                                       setDefault:^id _Nonnull{
                                                                           return [[UIFont systemFontOfSize:10] fontName];
                                                                       }];
    });
}

- (PSFontLevel)currentFontLevel{
    return _currentLevel ?: ({
        _currentLevel = [[[NSUserDefaults standardUserDefaults] ps_objectForKey:PSFontCenterCurrentFontLevelKey
                                                                    setDefault:^id _Nonnull{
                                                                        return @(PSFontLevelSystem);
                                                                    }] integerValue];
    });
}

#pragma mark - 全局调整字体
- (void)changeFontName:(NSString *)fontName{
    PSAssertParameter(fontName != nil && fontName.length > 0);
    _currentFontName = [fontName copy];
    [[NSUserDefaults standardUserDefaults] ps_setObject:_currentFontName forKey:PSFontCenterCurrentFontNameKey];
    [self ps_performBlockSync:^{
        for (id<PSFontObserver> observer in _observers) {
            [observer loadFont:self];
        }
    }];
}

- (void)changeFontLevel:(PSFontLevel)newLevel{
    _currentLevel = newLevel;
    [[NSUserDefaults standardUserDefaults] ps_setObject:@(newLevel) forKey:PSFontCenterCurrentFontLevelKey];
    
    [self ps_performBlockSync:^{
        for (id<PSFontObserver> observer in _observers) {
            [observer loadFont:self];
        }
    }];
}

- (void)changeFontLevel:(PSFontLevel)newLevel withFontName:(NSString *)fontName{
    PSAssertParameter(fontName != nil && fontName.length > 0);
    _currentLevel = newLevel;
    _currentFontName = [fontName copy];
    [[NSUserDefaults standardUserDefaults] ps_setObject:@(newLevel) forKey:PSFontCenterCurrentFontLevelKey];
    [[NSUserDefaults standardUserDefaults] ps_setObject:_currentFontName forKey:PSFontCenterCurrentFontNameKey];
    
    [self ps_performBlockSync:^{
        for (id<PSFontObserver> observer in _observers) {
            [observer loadFont:self];
        }
    }];
}

#pragma mark - 调整字体相关方法
- (CGFloat)fontSizeAfterAdjust:(CGFloat)originalSize{
    return originalSize + [self increasementForLevel:self.currentFontLevel];
}

- (UIFont *)fontAfterAdjust:(UIFont *)originalFont{
    return [UIFont fontWithName:originalFont.fontName size:[self fontSizeAfterAdjust:originalFont.pointSize]];
}

- (UIFont *)fontWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:self.currentFontName size:[self fontSizeAfterAdjust:fontSize]];
}

#pragma mark - 注册与应用主题
- (void)registerObserver:(id<PSFontObserver>)observer{
    [_observers addObject:observer];
}

- (void)applyThemeToObserver:(id<PSFontObserver>)observer{
    [observer loadFont:self];
}

- (void)autoRegisterClass:(Class)aClass beforeExecuting:(SEL)registeSEL applybeforeExecuting:(SEL)applySEL{
    //自动注册
    [PSAspect interceptSelector:registeSEL
                        inClass:aClass
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(PSFontObserver)]) {
            doIf(self.showLog, PSPrintf(@"🅰️🅰️PSFontCenter: Auto register instance: <%@ %p>\n", [invocation.target class], invocation.target));
            [[PSFontCenter center] registerObserver:invocation.target];
        }
        [invocation invoke];
    })];
    
    //自动应用字体
    [PSAspect interceptSelector:applySEL
                        inClass:aClass
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(PSFontObserver)]) {
            [invocation.target loadFont:[PSFontCenter center]];
        }
        [invocation invoke];
    })];
}
@end
