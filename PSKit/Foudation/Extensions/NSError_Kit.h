//
//  Kit.h
//  PSKit
//
//  Created by PoiSon on 16/2/29.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/PSKitDefines.h>

#define PSAssertError(condition, desc, ...) \
    do { \
        __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        if (!(condition)) { \
            @throw [NSError ps_errorWhenExecuting: __func__ \
                                           inFile: [NSString stringWithUTF8String:__FILE__] ?: @"<Unknown File>" \
                                           atLine: __LINE__ \
                                      description: desc, ##__VA_ARGS__]; \
        } \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

NS_ASSUME_NONNULL_BEGIN

PSKIT_EXTERN NSError *NSErrorWithLocalizedDescription(NSString *description);

@interface NSError (PSKit)
+ (instancetype)ps_errorWithLocalizedDescription:(NSString *)description;
+ (instancetype)ps_errorWhenExecuting:(const char *)function inFile:(NSString *)fileName atLine:(NSInteger)line description:(nullable NSString *)format, ...;
@end
NS_ASSUME_NONNULL_END