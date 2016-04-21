//
//  NSInvocation+Swizzling.m
//  PSKit
//
//  Created by PoiSon on 15/9/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSInvocation.h"
#import "PSFoudation.h"
#import "PSAspect.h"
#import <objc/message.h>

BOOL _ps_aspect_is_show_log = NO;

@implementation PSInvocation
- (void)invoke{
    PSInvocationDetails *details = [self.target _ps_details_for_invocation:self];
    
    NSArray<id<PSInterceptor>> *interceptors = details.interceptors;
    NSInteger index = details.index;
    if (index < interceptors.count) {
        id<PSInterceptor> interceptor = interceptors[interceptors.count - index - 1];
        details.index ++;

        if (_ps_aspect_is_show_log) {
            PSPrintf(@"🍁🍁PSAspect:<%@ %p> -[%@ %@] --> %@\n", NSStringFromClass([self.target class]), self.target, NSStringFromClass([(id)interceptor _ps_aspect_target]), NSStringFromSelector(self.selector), [interceptor description]);
        }
        
        [interceptor intercept:self];
    }else{
        self.selector = details.proxy_selector;
        [super invoke];
    }
}
@end

@implementation NSObject (PS_INVOCATION_TARGET_INTERCEPTORS)
- (NSMutableDictionary<NSNumber/*hash*/*, PSInvocationDetails *> *)_ps_details_invocation_map{
    PSAssociatedKeyAndNotes(PS_DETAILS_INVOCATION_MAP, "store the map of details");
    return [self ps_associatedObjectForKey:PS_DETAILS_INVOCATION_MAP storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id _Nonnull{
        return [NSMutableDictionary new];
    }];
}

- (PSInvocationDetails *)_ps_details_for_invocation:(NSInvocation *)invocation{
    return [[self _ps_details_invocation_map] objectForKey:@(invocation.hash)];
}

- (void)_ps_set_details:(PSInvocationDetails *)details for_invocation:(NSInvocation *)invocation{
    NSUInteger hash = [invocation hash];
    if (details == nil) {
        [[self _ps_details_invocation_map] removeObjectForKey:@(hash)];
    }else{
        [[self _ps_details_invocation_map] setObject:details forKey:@(hash)];
        [invocation ps_notificateWhenDealloc:^{
            [[self _ps_details_invocation_map] removeObjectForKey:@(hash)];
        }];
    }
}

PSAssociatedKeyAndNotes(PS_ASPECT_TARGET_KEY, "store the target class for interceptor");
- (void)_ps_set_aspect_target:(Class)target{
    [self ps_setAssociatedObject:target forKey:PS_ASPECT_TARGET_KEY];
}
- (Class)_ps_aspect_target{
    return [self ps_associatedObjectForKey:PS_ASPECT_TARGET_KEY];
}
@end

@implementation PSInvocationDetails
+ (instancetype)detailsWithProxySelector:(SEL)aSelector interceptors:(NSArray<id<PSInterceptor>> *)interceptors{
    PSInvocationDetails *details = [PSInvocationDetails new];
    details.proxy_selector = aSelector;
    details.interceptors = interceptors;
    details.index = 0;
    return details;
}
@end