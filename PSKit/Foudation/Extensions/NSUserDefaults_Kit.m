//
//  NSUserDefaults+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "NSUserDefaults_Kit.h"

@implementation NSUserDefaults (Kit)
- (void)ps_setObject:(id)value forKey:(NSString *)key{
    [self setObject:value forKey:key];
    [self synchronize];
}

- (id)ps_objectForKey:(NSString *)key setDefault:(id _Nonnull (^)())defaultValue{
    return [self objectForKey:key] ?: ({
        id value = defaultValue();
        [self ps_setObject:value forKey:key];
        value;
    });
}
@end
