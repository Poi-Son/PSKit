//
//  PSLog.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/PSConvenientMacro.h>

#ifdef PS_LOG_OFF
    #define PSLog(message, ...)
    #define PSLogD(message, ...)
    #define PSLogI(message, ...)
    #define PSLogW(message, ...)
    #define PSLogE(message, ...)

   #define PSLogObj(obj)
   #define PSLogTodo(user, comment)
   #define PSLogWarning(user, warning)
#else
    #define PSLog(message, ...) PSLogD(message, ##__VA_ARGS__)
    #define PSLogD(message, ...) __PSLoggerIns__.d(message, ##__VA_ARGS__)
    #define PSLogI(message, ...) __PSLoggerIns__.i(message, ##__VA_ARGS__)
    #define PSLogW(message, ...) __PSLoggerIns__.w(message, ##__VA_ARGS__)
    #define PSLogE(message, ...) __PSLoggerIns__.e(message, ##__VA_ARGS__)

    #define __PSLoggerIns__ [PSLog logFunc:__func__ file:__FILE__ line:__LINE__]

   #define PSLogObj(obj) PSLogD([obj description])

   #define PSLogTodo(user, comment) PSPrintf(@"✅✅TODO by %@: %@ (%@:%d)\n", user, comment, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
   #define PSLogWarning(user, warning) PSPrintf(@"⚠️⚠️WARNING by %@: %@ (%@:%d)\n", user, warning, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
#endif

#ifdef NS_LOG_OFF
    #define NSLog(message, ...)
#else
    #define NSLog(message, ...) \
        do { \
            PSPrintf(@"🐞🐞%s (%@: %d) \n", __func__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__); \
            NSLog(message, ##__VA_ARGS__); \
            PSPrintf(@"=========================================\n", NULL); \
        } while(0)
#endif

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void PSPrintf(NSString *format, ...);

typedef NS_ENUM(int, PSLogLevel) {
    PSEnumOption(PSLogLevelDEBUG, 1, "DEBUG"),
    PSEnumOption(PSLogLevelINFO, 1<<1, "INFO"),
    PSEnumOption(PSLogLevelWARNING, 1<<2, "WARNING"),
    PSEnumOption(PSLogLevelERROR, 1<<3, "ERROR")
};

@protocol PSLogger <NSObject>
- (void)logLevel:(PSLogLevel)level func:(const char *)func file:(const char *)file line:(NSInteger)line message:(NSString *)msg;
@end
                  
/**
 *  默认使用PSConsoleLogger
 */
@interface PSLog : NSObject
+ (void)use:(nonnull id<PSLogger>)logger;

+ (void)enable:(int)level;/**< 只允许记录指定级别的日志 */

+ (instancetype)logFunc:(const char *)func file:(const char *)file line:(NSInteger)line;
@property (nonatomic, readonly) void (^d)(NSString *format, ...);/**< DEBUG */
@property (nonatomic, readonly) void (^i)(NSString *format, ...);/**< INFO */
@property (nonatomic, readonly) void (^w)(NSString *format, ...);/**< WARNING */
@property (nonatomic, readonly) void (^e)(NSString *format, ...);/**< ERROR */
@end
NS_ASSUME_NONNULL_END