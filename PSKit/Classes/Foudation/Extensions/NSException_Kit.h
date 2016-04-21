//
//  NSExceptionKit.h
//  PSKit
//
//  Created by PoiSon on 15/10/6.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PSAssert(condition, desc, ...) \
    do { \
        __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        if (!(condition)) { \
            @throw [NSException ps_exceptionWhenExecuting: __func__ \
                                                   inFile: [NSString stringWithUTF8String:__FILE__] ?: @"<Unknown File>" \
                                                   atLine: __LINE__ \
                                              description: desc, ##__VA_ARGS__]; \
        } \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

#define PSAssertFail(desc, ...) PSAssert(NO, desc, ##__VA_ARGS__)
#define PSAssertParameter(condition) PSAssert((condition), @"Invalid parameter not satisfying: %@", @#condition)

NS_ASSUME_NONNULL_BEGIN
@interface NSException (Kit)
+ (instancetype)ps_exceptionWhenExecuting:(const char *)function inFile:(NSString *)fileName atLine:(NSInteger)line description:(nullable NSString *)format, ...;
@end
NS_ASSUME_NONNULL_END
