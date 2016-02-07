//
//  NSSet+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/10/24.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@implementation NSSet (PSSearch)
- (NSSet *)ps_setWithCondition:(BOOL (^)(id _Nonnull))condition{
    NSMutableSet *result = [NSMutableSet set];
    for (id obj in self) {
        doIf(condition(obj), [result addObject:obj]);
    }
    return result;
}

- (NSSet *)ps_removeWithCondition:(BOOL (^)(id _Nonnull))condition{
    NSMutableSet *result = [self mutableCopy];
    for (id obj in self) {
        doIf(condition(obj), [result removeObject:obj]);
    }
    return result;
}

- (NSSet *)ps_setInSet:(NSSet *)set{
    NSMutableSet *result = [NSMutableSet new];
    for (id obj in set) {
        doIf([self containsObject:obj], [result addObject:obj]);
    }
    return result;
}
@end

@implementation NSSet (Kit)
- (NSString *)ps_join:(NSString *)separator{
    NSMutableString *result = [NSMutableString new];
    for (id value in self) {
        doIf(result.length, [result appendString:separator]);
        [result appendFormat:@"%@", value];
    }
    return result;
}

- (NSArray *)ps_toArray{
    NSMutableArray *result = [NSMutableArray new];
    for (id obj in self) {
        [result addObject:obj];
    }
    return result;
}

- (NSMutableArray *)ps_toMutableArray{
    NSMutableArray *result = [NSMutableArray new];
    for (id obj in self) {
        [result addObject:obj];
    }
    return result;
}
@end
