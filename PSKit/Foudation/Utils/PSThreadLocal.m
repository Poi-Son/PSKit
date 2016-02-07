//
//  PSThreadLocal.m
//  PSKit
//
//  Created by PoiSon on 15/10/11.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSThreadLocal.h"
#import "PSFoudation.h"

@interface PSSuppliedThreadLocal : PSThreadLocal
@end

@implementation PSThreadLocal{
    NSString *_identifier;
}

- (instancetype)initWithSupplier:(id<PSThreadLocalSupplier>)supplier{
    return [[PSSuppliedThreadLocal alloc] initWithSupplier:supplier];
}

- (void)remove{
    @synchronized(self) {
        [[NSThread currentThread].threadDictionary removeObjectForKey:self.identifier];
    }
}

- (id)value{
    @synchronized(self) {
        return [[NSThread currentThread].threadDictionary objectForKey:self.identifier];
    }
}

- (void)setValue:(id)value{
    @synchronized(self) {
        if (value) {
            [[NSThread currentThread].threadDictionary setValue:value forKey:self.identifier];
        }else{
            [[NSThread currentThread].threadDictionary removeObjectForKey:self.identifier];
        }
    }
}

- (NSString *)identifier{
    return _identifier ?: (_identifier = format(@"PSThreadLocalKey_%p", self));
}
@end

@implementation PSSuppliedThreadLocal{
    __weak id<PSThreadLocalSupplier> _supplier;
}
-(instancetype)initWithSupplier:(id<PSThreadLocalSupplier>)supplie{
    if (self = [super init]) {
        _supplier = supplie;
    }
    return self;
}

- (id)value{
    @synchronized(self) {
        return [[NSThread currentThread].threadDictionary ps_objectForKey:self.identifier
                                                                   setDefault:^id _Nonnull{
                                                                       id result = [_supplier initialValueForthreadLocal:self];
                                                                       PSAssert(result, @"supplier can't return a nil value");
                                                                       return result;
                                                                   }];
    }
}
@end