//
//  NSObject+PSFuncLock.m
//  PSKit
//
//  Created by PoiSon on 15/11/30.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"
#import "PSAspect.h"

#define ProxyPrefix format(@"__ps_proxy_%@_", NSStringFromClass(self.class))

@implementation NSObject (PSFuncLock)
- (NSMutableSet *)_ps_locked_func_set{
    PSAssociatedKeyAndNotes(PS_FUNC_LOCK_STATE, "Store the state of the function");
    return [self ps_associatedObjectForKey:PS_FUNC_LOCK_STATE storeProlicy:PSStoreUsingRetain setDefault:^id _Nonnull{
        return [NSMutableSet new];
    }];
}

- (BOOL)_ps_is_func_locked:(SEL)selector{
    NSMutableSet *set = [self _ps_locked_func_set];
    return [set containsObject:NSStringFromSelector(selector)];
}

- (void)_set_func:(SEL)selector locked:(BOOL)isLocked{
    NSMutableSet *set = [self _ps_locked_func_set];
    
    NSString *realSelectorStr = [NSStringFromSelector(selector) ps_replaceAll:ProxyPrefix with:@""];
    if (isLocked) {
        [set addObject:realSelectorStr];
    }else{
        [set removeObject:realSelectorStr];
    }
}

- (void)_ps_enhance_func_for_lock:(SEL)selector{
    if (![NSStringFromSelector(selector) hasPrefix:ProxyPrefix]) {
        [PSAspect interceptSelector:selector
                         inInstance:self
                    withInterceptor:interceptor(^(NSInvocation *invocation) {
            if ([invocation.target _ps_is_func_locked:invocation.selector]) {
                PSPrintf(@"%@ -[%@ %@] was locked, target for selector is forwarding to nil.\n",[[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], NSStringFromClass([invocation.target class]), NSStringFromSelector(invocation.selector));
                id nilTarget = nil;
                [invocation invokeWithTarget:nilTarget];
            }else{
                [invocation invoke];
            }
        })];
    }
}

- (void)ps_lockFunc:(SEL)selector unlockDelay:(NSTimeInterval)delay{
    [self ps_performBlockLocked:^{
        if (![self _ps_is_func_locked:selector]) {
            [self _ps_enhance_func_for_lock:selector];
            [self _set_func:selector locked:YES];
            doIf(delay > 0, [self ps_performBlockSync:^{
                [self ps_performBlockSync:^{
                    [self ps_unlockFunc:selector];
                } afterDelay:delay];
            }]);
        }
    }];
}

- (void)ps_unlockFunc:(SEL)selector{
    [self ps_performBlockLocked:^{
        [self _set_func:selector locked:NO];
    }];
}
@end
