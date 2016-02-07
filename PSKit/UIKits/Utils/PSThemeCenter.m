//
//  PSThemeManager.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSThemeCenter.h"
#import "PSFoudation.h"
#import "PSAspect.h"

static NSString * PSThemeManagerKey = @"PS_THEME_MANAGER_KEY";

@interface PSThemeCenter()
@property (nonatomic, strong) NSMutableDictionary *registedThemes;
@property (nonatomic, strong) NSHashTable *observers;
@end

@implementation PSThemeCenter{
    PSTheme *_currentTheme;
    NSString *_currentThemeName;
}
- (instancetype)_init{
    if (self = [super init]) {
        self.registedThemes = [NSMutableDictionary new];
        self.observers = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
- (instancetype)init{
    PSAssertFail(@"使用[PSThemeCenter center]来获取实例");
    return nil;
}

+ (instancetype)center{
    static PSThemeCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PSThemeCenter alloc] _init];
    });
    return instance;
}

- (void)registerTheme:(PSTheme *)theme forName:(NSString *)themeName{
    PSAssert(![self.registedThemes ps_containsKey:themeName], format(@"已存在名为【%@】的主题", themeName));
    [self.registedThemes setObject:theme forKey:themeName];
}

- (void)registerObserver:(id<PSThemeObserver>)observer{
    PSAssertParameter(observer != nil);
    [self.observers addObject:observer];
}

- (void)applyThemeToObserver:(id<PSThemeObserver>)observer{
    [observer loadTheme:self.currentTheme];
}

- (void)changeThemeWithName:(NSString *)themeName{
    PSAssertParameter(themeName != nil && themeName.length > 0);
    PSAssert([self.registedThemes ps_containsKey:themeName], format(@"不存在名为【%@】的主题", themeName));
    PSTheme *theme = [self.registedThemes objectForKey:themeName];
    
    _currentTheme = theme;
    _currentThemeName = themeName;
    //保存主题信息
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:PSThemeManagerKey];
    
    [self ps_performBlockSync:^{
        //应用主题
        for (id<PSThemeObserver> observer in self.observers) {
            [observer loadTheme:_currentTheme];
        }
    }];
}

- (PSTheme *)currentTheme{
    if (!_currentTheme) {
        PSAssert(self.registedThemes.count, @"程序没有注册主题, 无法获取主题");
        _currentTheme = [self.registedThemes objectForKey:self.currentThemeName];
    }
    return _currentTheme;
}

- (NSString *)currentThemeName{
    return _currentThemeName ?: ({
        _currentThemeName = [[NSUserDefaults standardUserDefaults] ps_objectForKey:PSThemeManagerKey setDefault:^{
            return [self.registedThemes allKeys][0];
        }];
    });
}

- (void)autoRegisterClass:(Class)aClass beforeExecuting:(SEL)registeSEL applyBeforeExecuting:(SEL)applySEL{
    //自动注册
    [PSAspect interceptSelector:registeSEL
                        inClass:aClass
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(PSThemeObserver)]) {
            doIf(self.showLog, PSPrintf(@"🌈🌈PSThemeCenter: Auto register instance: <%@ %p>\n", [invocation.target class], invocation.target));
            [[PSThemeCenter center] registerObserver:invocation.target];
        }
        [invocation invoke];
    })];
    
    //自动应用主题
    [PSAspect interceptSelector:applySEL
                        inClass:aClass
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(PSThemeObserver)]) {
            [invocation.target loadTheme:[PSThemeCenter center].currentTheme];
        }
        [invocation invoke];
    })];
}
@end

@implementation PSTheme{
    NSMapTable<NSString *, UIImage *> *_imageCache;
    NSMapTable<NSString *, UIColor *> *_colorCache;
    NSDictionary<NSString *,NSString *> *_colorDic;
}

- (NSMapTable<NSString *, UIImage *> *)imageCache{
    return _imageCache ?: ({_imageCache = [NSMapTable strongToWeakObjectsMapTable];});
}

- (NSMapTable<NSString *, UIColor *> *)colorCache{
    return _colorCache ?: ({_colorCache = [NSMapTable strongToWeakObjectsMapTable];});
}

- (NSDictionary<NSString *, NSString *> *)colorDic{
    return _colorDic ?: ({_colorDic = [self colorDictionary]; });
}

- (UIColor *)colorForName:(NSString *)colorName{
    return [[self colorCache] objectForKey:colorName] ?: ({
        UIColor *color = [UIColor ps_colorFromString:[self.colorDic objectForKey:colorName]];
        [[self colorCache] setObject:color forKey:colorName];
        color;
    });
}

- (UIImage *)imageForName:(NSString *)imageName{
    NSString *themeName = [self themeNameFor:imageName];
    return [[self imageCache] objectForKey:themeName] ?: ({
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[self imageBundle] pathForResource:themeName ofType:nil]];
        [[self imageCache] setObject:image forKey:themeName];
        image;
    });
}

- (void)imageForName:(NSString *)imageName asyncCallback:(void (^)(UIImage *))callback{
    [self ps_performBlockAsync:^{
        UIImage *image = [self imageForName:imageName];
        [self ps_performBlockSync:^{
            callback(image);
        }];
    }];
}

#pragma mark - 主题子类需要实现的方法
- (NSDictionary<NSString *,NSString *> *)colorDictionary{
    [self doesNotRecognizeSelector:@selector(colorDictionary)];
    return nil;
}

- (NSString *)themeNameFor:(NSString *)name{
    return name;
}

- (NSBundle *)imageBundle{
    return [NSBundle mainBundle];
}
@end
