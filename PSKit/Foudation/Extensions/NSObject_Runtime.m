//
//  NSObject+Runtime.m
//  PSKit
//
//  Created by PoiSon on 15/9/24.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"
#import "PSDeallocNotification.h"
#import <objc/runtime.h>

@implementation NSObject (PSRuntime)

+ (BOOL)ps_isSubclassOfClass:(Class)aClass{
    returnValIf(self.class == aClass, NO);
    return [self isSubclassOfClass:aClass];
}

- (void)ps_notificateWhenDealloc:(void (^)(void))notification{
    [PSDeallocNotification notificateWhenInstanceDelloc:self withCallback:notification];
}

- (void)ps_setAssociatedObject:(id)value forKey:(const void *)key usingProlicy:(PSStorePolicy)policy{
    objc_setAssociatedObject(self, key, value, (objc_AssociationPolicy)policy);
}

- (void)ps_setAssociatedObject:(id)value forKey:(const void *)key{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ps_associatedObjectForKey:(const void *)key{
    return objc_getAssociatedObject(self, key);
}

- (id)ps_associatedObjectForKey:(const void *)key storeProlicy:(PSStorePolicy)policy setDefault:(id (^)(void))defaultValue{
    return objc_getAssociatedObject(self, key) ?: ({id value = defaultValue(); objc_setAssociatedObject(self, key, value, (objc_AssociationPolicy)policy); value;});
}

+ (void)ps_setAssociatedObject:(id)value forKey:(const void *)key usingProlicy:(PSStorePolicy)policy{
    objc_setAssociatedObject(self, key, value, (objc_AssociationPolicy)policy);
}

+ (void)ps_setAssociatedObject:(id)value forKey:(const void *)key{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)ps_associatedObjectForKey:(const void *)key{
    return objc_getAssociatedObject(self, key);
}

+ (id)ps_associatedObjectForKey:(const void *)key storeProlicy:(PSStorePolicy)policy setDefault:(id  _Nonnull (^)(void))defaultValue{
    return objc_getAssociatedObject(self, key) ?: ({id value = defaultValue(); objc_setAssociatedObject(self, key, value, (objc_AssociationPolicy)policy); value;});
}

@end
