//
//  NSObject+PSKVO.m
//  PSKit
//
//  Created by PoiSon on 15/12/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@interface PSKVOObserver : NSObject
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *blocks;
@end

@implementation NSObject (PSKVO)
- (PSKVOObserver *)ps_observer{
    PSAssociatedKeyAndNotes(PS_KVO_OBSERVER_KEY, "保存观察者的实例");
    return [self ps_associatedObjectForKey:PS_KVO_OBSERVER_KEY
                              storeProlicy:PSStoreUsingRetainNonatomic
                                setDefault:^id _Nonnull{
                                    return [PSKVOObserver new];
                                }];
}

- (void)ps_addObserver:(void (^)(id _Nonnull, NSDictionary<NSString *,id> * _Nonnull))block forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options{
    PSKVOObserver *observer = [self ps_observer];
    [[observer.blocks ps_objectForKey:keyPath setDefault:^{return [NSMutableArray new];}] addObject:[block copy]];
    [self addObserver:observer forKeyPath:keyPath options:options context:nil];
}

- (void)ps_clearObserversForKeyPath:(NSString *)keyPath{
    PSKVOObserver *observer = [self ps_observer];
    [[observer.blocks objectForKey:keyPath] removeAllObjects];
    [self removeObserver:observer forKeyPath:keyPath];
}

@end

@implementation PSKVOObserver

- (NSMutableDictionary<NSString *,NSMutableArray *> *)blocks{
    return _blocks ?: (_blocks = [NSMutableDictionary new]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSMutableArray *blocks = [[self blocks] objectForKey:keyPath];
    for (void(^block)(id, NSDictionary<NSString *, id> *) in blocks) {
        block(object, change);
    }
}
@end