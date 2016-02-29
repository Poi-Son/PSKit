//
//  Kit.m
//  PSKit
//
//  Created by PoiSon on 16/2/29.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import "NSError_Kit.h"
#import "NSBundle_Kit.h"

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
@end
