//
//  PSJson_Kit.m
//  PSKit
//
//  Created by PoiSon on 15/11/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@implementation NSString (Json)
- (id)ps_jsonContainer{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonContainer];
}

- (NSArray *)ps_jsonArray{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonArray];
}

- (NSDictionary *)ps_jsonDictionary{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonDictionary];
}

- (id)ps_jsonMutableContainer{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonMutableContainer];
}

- (NSMutableArray *)ps_jsonMutableArray{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonMutableArray];
}

- (NSMutableDictionary *)ps_jsonMutableDictionary{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ps_jsonMutableDictionary];
}
@end

@implementation NSDictionary (Json)
- (NSData *)ps_toJsonData{
    NSData *result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    return result;
}

- (NSString *)ps_toJsonString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    return data == nil ? nil : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

@implementation NSArray (Json)
- (NSData *)ps_toJsonData{
    NSData *result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    return result;
}

- (NSString *)ps_toJsonString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    return data == nil ? nil : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

@implementation NSData (Json)
- (id)ps_jsonContainer{
    NSData *result = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
    return result;
}

- (NSArray *)ps_jsonArray{
    id result = [self ps_jsonContainer];
    returnValIf(!result, nil);
    PSAssert([result isKindOfClass:[NSArray class]], @"cant conver data to NSArray, target is '%@'", [result class]);
    return result;
}

- (NSDictionary *)ps_jsonDictionary{
    id result = [self ps_jsonContainer];
    returnValIf(!result, nil);
    PSAssert([result isKindOfClass:[NSDictionary class]], @"cant conver data to NSDictionary, target is '%@'", [result class]);
    return result;
}

- (id)ps_jsonMutableContainer{
    id result = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    return result;
}

- (NSMutableArray *)ps_jsonMutableArray{
    id result = [self ps_jsonMutableContainer];
    returnValIf(!result, nil);
    PSAssert([result isKindOfClass:[NSMutableArray class]], @"cant conver data to NSMutableArray, target is '%@'", [result class]);
    return result;
}

- (NSMutableDictionary *)ps_jsonMutableDictionary{
    id result = [self ps_jsonMutableContainer];
    returnValIf(!result, nil);
    PSAssert([result isKindOfClass:[NSMutableDictionary class]], @"cant conver data to NSMutableDictionary, target is '%@'", [result class]);
    return result;
}
@end