//
//  NSDictionary+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@implementation NSDictionary (Kit)
- (id)ps_objectForKey:(id)key useDefault:(id (^)())defaultValue{
    return [self objectForKey:key] ?: defaultValue();
}
- (BOOL)ps_containsKey:(id)key{
    return [[self allKeys] containsObject:key];
}
@end

@implementation NSMutableDictionary (Kit)
- (id)ps_objectForKey:(id)key setDefault:(id (^)())defaultValue{
    return [self objectForKey:key] ?: ({id value = defaultValue(); [self setObject:value forKey:key]; value;});
}
@end
