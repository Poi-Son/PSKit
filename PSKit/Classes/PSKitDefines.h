//
//  PSKitDefines.h
//  PSKit
//
//  Created by PoiSon on 16/2/19.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#ifndef PSKitDefines_h
#define PSKitDefines_h

#if defined(__cplusplus)
#define PSKIT_EXTERN extern "C"
#else
#define PSKIT_EXTERN extern
#endif

#define PSKIT_EXTERN_STRING(KEY, COMMENT) PSKIT_EXTERN NSString * const _Nonnull KEY;
#define PSKIT_EXTERN_STRING_IMP(KEY) NSString * const KEY = @#KEY;
#define PSKIT_EXTERN_STRING_IMP2(KEY, VAL) NSString * const KEY = VAL;

#define PSKIT_ENUM_OPTION(ENUM, VAL, COMMENT) ENUM = VAL

#define PSKIT_API_UNAVAILABLE(INFO) __attribute__((unavailable(INFO)))

#define PSKIT_IGNORE_PERFORMSELECTOR_LEAKS(action) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        action; \
        _Pragma("clang diagnostic pop") \
    } while (0)

#endif /* PSKitDefines_h */
