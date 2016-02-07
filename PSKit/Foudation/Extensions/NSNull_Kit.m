//
//  NSNull+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/11/10.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "NSNull_Kit.h"
#import "PSFoudation.h"

@implementation NSNull (Safe)

static BOOL _ps_enabled = NO;
+ (void)ps_setNullSafeEnabled:(BOOL)enabled{
    _ps_enabled = enabled;
}
- (id)forwardingTargetForSelector:(SEL)aSelector{
    returnValIf(!_ps_enabled, nil);
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    returnValIf(!_ps_enabled, nil);
    
    static NSMethodSignature *signature;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    });
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    id target = nil;
    [anInvocation invokeWithTarget:target];
}
@end
