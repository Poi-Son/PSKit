//
//  NSMutableArray+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@implementation NSArray (PSSearch)
- (NSArray *)ps_arrayWithCondition:(BOOL (^)(id _Nonnull))condition{
    NSMutableArray *result = [NSMutableArray new];
    for (id obj in self) {
        doIf(condition(obj), [result addObject:obj]);
    }
    return result;
}

- (NSArray *)ps_removeWithCondition:(BOOL (^)(id _Nonnull))condition{
    NSMutableArray *result = [self mutableCopy];
    for (id obj in self) {
        doIf(condition(obj), [result removeObject:obj]);
    }
    return result;
}

- (NSArray *)ps_arrayInArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray new];
    for (id obj in array) {
        doIf([self containsObject:obj], [result addObject:obj]);
    }
    return result;
}
@end

@implementation NSArray (Kit)
- (NSArray *)ps_objectsBeforIndex:(NSUInteger)index{
    if (self.count < index) {
        return self;
    }else{
        return [self subarrayWithRange:NSMakeRange(0, index)];
    }
}

- (NSArray *)ps_objectsAfterIndex:(NSUInteger)index{
    if (self.count < index) {
        return self;
    }else{
        return [self subarrayWithRange:NSMakeRange(self.count - index, index)];
    }
}

- (NSArray *)ps_objectsInRange:(NSRange)range{
    return [self subarrayWithRange:range];
}

- (instancetype)reverse{
    return [NSMutableArray ps_arrayWithEnumerator:self.reverseObjectEnumerator];
}

- (NSString *)ps_join:(NSString *)separator{
    NSMutableString *result = [NSMutableString new];
    for (id value in self) {
        doIf(result.length, [result appendString:separator]);
        [result appendFormat:@"%@", value];
    }
    return result;
}

- (NSSet *)ps_toSet{
    return [NSSet setWithArray:self];
}

- (NSMutableSet *)ps_toMutableSet{
    return [NSMutableSet setWithArray:self];
}

- (instancetype)ps_initWithEnumerator:(NSEnumerator *)enumerator{
    NSMutableArray *array = [NSMutableArray array];
    id obj;
    while ((obj = enumerator.nextObject)) {
        [array addObject:obj];
    }
    return array;
}

+ (instancetype)ps_arrayWithEnumerator:(NSEnumerator *)enumerator{
    return [[self alloc] ps_initWithEnumerator:enumerator];
}

@end

@implementation NSMutableArray (Kit)
- (void)ps_removeObjectsFormArray:(NSArray *)array{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObject:obj];
    }];
}

- (void)ps_replaceObject:(id)obj withObjec:(id)anotherObj{
    if ([self containsObject:obj]) {
        [self replaceObjectAtIndex:[self indexOfObject:obj] withObject:anotherObj];
    }
}

- (void)ps_moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    PSAssert(fromIndex < self.count && fromIndex >= 0, @"fromIndex out of bounds");
    PSAssert(toIndex < self.count && toIndex >= 0, @"toIndex out of bounds");
    id obj = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:obj atIndex:toIndex];
}

- (void)ps_insertObjectAtFirst:(id)obj{
    [self insertObject:obj atIndex:0];
}

- (void)ps_insertObjectsAtFirst:(NSArray *)array{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    [newArray addObject:self];
    [self removeAllObjects];
    [self addObjectsFromArray:newArray];
}

- (id)ps_removeFirstObject{
    id obj = nil;
    if (self.count) {
        obj = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
    }
    return obj;
}

- (NSArray *)ps_removeFirstObjects:(NSUInteger)count{
    NSMutableArray *removedObjects = [NSMutableArray new];
    if (count >= self.count) {
        [removedObjects addObjectsFromArray:self];
        [self removeAllObjects];
    }else {
        [removedObjects addObjectsFromArray:[self ps_objectsInRange:NSMakeRange(0, count)]];
        [self removeObjectsInRange:NSMakeRange(0, count)];
    }
    return removedObjects;
}

- (void)ps_addObject:(id)obj{
    [self addObject:obj];
}

- (void)ps_addObjects:(NSArray *)array{
    [self addObjectsFromArray:array];
}

- (id)ps_removeLastObject{
    id lastObject = nil;
    if (self.count) {
        lastObject = [self lastObject];
        [self removeLastObject];
    }
    return lastObject;
}

- (NSArray *)ps_removeLastObjects:(NSUInteger)count{
    NSMutableArray *removedObjects = [NSMutableArray new];
    if (count >= self.count) {
        [removedObjects addObjectsFromArray:self];
        [self removeAllObjects];
    }else{
        [removedObjects addObjectsFromArray:[self ps_objectsInRange:NSMakeRange(self.count - count, count)]];
        [self removeObjectsInRange:NSMakeRange(self.count - count, count)];
    }
    return removedObjects;
}

- (void)ps_addObjectsFormEnumerator:(NSEnumerator *)enumerator{
    id obj;
    while ((obj = enumerator.nextObject)) {
        [self addObject:obj];
    }
}
@end
