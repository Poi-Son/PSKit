//
//  PSLog.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSLog.h"
#import "PSFoudation.h"
#import "PSConsoleLogger.h"
#import <libkern/OSAtomic.h>

@implementation PSLog{
    const char *_func;
    const char *_file;
    NSInteger _line;
}

static id<PSLogger> _logger;
id<PSLogger> getLogger(){
    return _logger ?: (_logger = [PSConsoleLogger new]);
}

+ (void)use:(id<PSLogger>)newLogger{
    PSAssertParameter(newLogger != nil);
    _logger = newLogger;
}

static PSLogLevel enabled = PSLogLevelERROR | PSLogLevelWARNING | PSLogLevelDEBUG | PSLogLevelINFO;
+ (void)enable:(int)level{
    PSAssertParameter(level & (PSLogLevelERROR | PSLogLevelWARNING | PSLogLevelDEBUG | PSLogLevelINFO));
    enabled = level;
}

- (instancetype)initWithFunc:(const char *)func file:(const char *)file line:(NSInteger)line{
    if (self = [super init]) {
        _func = func;
        _file = file;
        _line = line;
    }
    return self;
}

+ (instancetype)logFunc:(const char *)func file:(const char *)file line:(NSInteger)line{
    return [[self alloc] initWithFunc:func file:file line:line];
}

#define LOG_IMP(fun, level) \
- (void (^)(NSString * _Nonnull, ...))fun{ \
    return ^(NSString *format, ...){ \
        if ((enabled & level) == 0) return; \
        va_args(format); \
        NSString *message = [[NSString alloc] initWithFormat:format arguments:format_args]; \
        [getLogger() logLevel:level func:_func file:_file line:_line message:message]; \
    }; \
}
LOG_IMP(d, PSLogLevelDEBUG);
LOG_IMP(i, PSLogLevelINFO);
LOG_IMP(w, PSLogLevelWARNING);
LOG_IMP(e, PSLogLevelERROR);
#undef LOG_IMP
@end

void PSPrintf(NSString *format, ...){
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    
    __block va_list params;
    va_start(params, format);
    printf([[NSString alloc] initWithFormat:format arguments:params].UTF8String, NULL);
    va_end(params);
    
    OSSpinLockUnlock(&aspect_lock);
}