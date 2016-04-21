//
//  NSException+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/10/6.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "NSException_Kit.h"
#import "PSFoudation.h"

@implementation NSException (Kit)
+ (instancetype)ps_exceptionWhenExecuting:(const char *)function inFile:(NSString *)fileName atLine:(NSInteger)line description:(NSString *)format, ...{
    va_args(format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:format_args];
    PSPrintf(@"❌❌❌❌❌❌❌❌❌❌ Assertion failure ❌❌❌❌❌❌❌❌❌❌\n%@ %s (%@: %@)\n%@\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌ ❌❌❌❌❌❌❌❌❌❌❌❌❌❌\n", [[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], function, [fileName lastPathComponent], @(line), reason);
    
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:@{@"function": [NSString stringWithUTF8String:function], @"file": fileName, @"lineNumber": @(line)}];
}
@end
