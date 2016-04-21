//
//  Kit.m
//  PSKit
//
//  Created by PoiSon on 16/2/29.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import "NSError_Kit.h"
#import "NSBundle_Kit.h"
#import "PSFoudation.h"

@implementation NSError (PSKit)
+ (instancetype)ps_errorWithLocalizedDescription:(NSString *)description{
    static NSString *domain;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        domain = [NSBundle mainBundle].infoDictionary[PSBundleName];
        domain = domain ?: @"none domain";
    });
    return [self errorWithDomain:domain code:-1000 userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (instancetype)ps_errorWhenExecuting:(const char *)function inFile:(NSString *)fileName atLine:(NSInteger)line description:(NSString *)format, ...{
    static NSString *domain;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        domain = [NSBundle mainBundle].infoDictionary[PSBundleName];
        domain = domain ?: @"none domain";
    });
    
    va_args(format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:format_args];
    
    return [self errorWithDomain:domain code:-1000 userInfo:@{
                                                              NSLocalizedDescriptionKey: reason,
                                                              @"Function": @(function),
                                                              @"Line": @(line),
                                                              @"FileName": [fileName lastPathComponent]
                                                              }];
}
@end

NSError *NSErrorWithLocalizedDescription(NSString *description){
    return [NSError ps_errorWithLocalizedDescription:description];
}