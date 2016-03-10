//
//  PSAspect-C.m
//  PSKit
//
//  Created by PoiSon on 15/12/21.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSAspect.h"
#import "PSFoudation.h"
#import "PSInvocation.h"
#import "runtime.h"

#define ProxySelector(class, selector) NSSelectorFromString(NSStringWithFormat(@"__ps_proxy_%@_%@", NSStringFromClass(class), NSStringFromSelector(selector)))

@interface NSObject (PSAspect_Associated_Info)
#pragma mark - instance interceptors
- (NSMutableDictionary<NSString *, NSMutableArray<id<PSInterceptor>> *> *)_ps_aspect_map; /**< cache instance selector-interceptor */
- (NSArray<id<PSInterceptor>> *)_ps_interceptors_for_selector:(SEL)aSelector; /**< get interceptors for selector in instance. */

#pragma mark - class interceptors
+ (NSMutableArray<id<PSInterceptor>> *)_ps_interceptors_for_selector:(SEL)aSelector; /**< get interceptors for selector in class*/
+ (void)_ps_clear_all_interceptors; /**< remove all interceptors in class */

#pragma mark - utils
+ (NSMutableSet<NSString *> *)_ps_aspected_selectors;/**< store the method names which were aspected. */
@end

#pragma mark - PSAspect
@implementation PSAspect
+ (void)showLog:(BOOL)isShow{
    _ps_aspect_is_show_log = YES;
}
@end

@implementation PSAspect (Priviate)
+ (NSMutableSet<Class> *)_aspected_classes{
    PSAssociatedKeyAndNotes(PS_ASPECTED_CLASSES, "Store the aspected classes");
    return [self ps_associatedObjectForKey:PS_ASPECTED_CLASSES storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id _Nonnull{
        return [NSMutableSet new];
    }];
}

+ (NSSet<NSString *> *)_unaspectable_selectors{
    static NSSet<NSString *> *unaspectableSelectors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unaspectableSelectors = [NSSet setWithObjects:@"retain", @"release", @"autorelease", @"dealloc", @"forwardInvocation:", @"forwardingTargetForSelector", nil];
    });
    return unaspectableSelectors;
}

+ (void)_check_if_aspectable_selector:(SEL)aSelector in_class:(Class)aClass{
    PSAssert(![[self _unaspectable_selectors] containsObject:NSStringFromSelector(aSelector)], @"PSAspect can not complete: Selector: %@ is not allowed to aspect.", NSStringFromSelector(aSelector));
    
    for (Class cls in [self _aspected_classes]) {
        if ([[cls _ps_aspected_selectors] containsObject:NSStringFromSelector(aSelector)]) {
            PSAssert(![cls ps_isSubclassOfClass:aClass], @"PSAspect can not complete: The subclass<%@> of <%@> has aspect the selector: %@, aspect same selector in inheritance may cause bugs.", NSStringFromClass(cls), NSStringFromClass(aClass), NSStringFromSelector(aSelector));
            PSAssert(![aClass ps_isSubclassOfClass:cls], @"PSAspect can not complete: The superclass<%@> of <%@> has aspect the selector: %@, aspect same selector in inheritance may cause bugs.", NSStringFromClass(cls), NSStringFromClass(aClass), NSStringFromSelector(aSelector));
        }
    }
}

/** make a proxy selector instead origin selector. */
+ (void)_proxy_selector:(SEL)aSelector in_class:(Class)aClass{
    // check if there is any aspected selector in superclass/subclass
    [self _check_if_aspectable_selector:aSelector in_class:aClass];
    
    [self _aspect_class:aClass];
    
    returnIf([[aClass _ps_aspected_selectors] containsObject:NSStringFromSelector(aSelector)]);
    [[aClass _ps_aspected_selectors] addObject:NSStringFromSelector(aSelector)];
    
    // find method from target class
    Method originalMethod = class_getInstanceMethod(aClass, aSelector);
    
    // copy method into target class if method is implement in superclass
    if (ps_class_getInstanceMethod(aClass, aSelector) == nil) {
        class_addMethod(aClass, aSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        originalMethod = class_getInstanceMethod(aClass, aSelector);
    }
    
    SEL proxySEL = ProxySelector(aClass, aSelector);
    IMP proxyIMP;
    if ([aClass instanceMethodSignatureForSelector:aSelector].methodReturnLength > 2 * sizeof(NSInteger)) {
#ifdef __arm64__
        proxyIMP = (IMP)_objc_msgForward;
#else
        proxyIMP = (IMP)_objc_msgForward_stret;
#endif
    }else{
        proxyIMP = (IMP)_objc_msgForward;
    }
    
    // add implementation into target class
    class_addMethod(aClass, proxySEL, proxyIMP, method_getTypeEncoding(originalMethod));
    Method proxyMethod = class_getInstanceMethod(aClass, proxySEL);
    
    // exchange the proxy method.
    method_exchangeImplementations(originalMethod, proxyMethod);
}

/** add method [-forwardingTargetForSelector:] and [-forwardInvocation:] to the class. */
+ (void)_aspect_class:(Class)aClass{
    returnIf([[self _aspected_classes] containsObject:aClass]);
    [[self _aspected_classes] addObject:aClass];
    
    //add forwardingTargetForSelector: implementation
    IMP forwardingIMP = imp_implementationWithBlock(^id(id target, SEL selector){
        if ([[aClass _ps_aspected_selectors] containsObject:NSStringFromSelector(selector)]) {
            return target;
        }else{
            SEL proxyForwardingSel = ProxySelector(aClass, @selector(forwardingTargetForSelector:));
            if ([aClass instancesRespondToSelector:proxyForwardingSel]){
                return ((id(*)(struct objc_super *, SEL, SEL))objc_msgSendSuper)(&(struct objc_super){target, aClass}, proxyForwardingSel, selector);
            }else{
                return ((id(*)(struct objc_super *, SEL, SEL))objc_msgSendSuper)(&(struct objc_super){target, [aClass superclass]}, @selector(forwardingTargetForSelector:), selector);
            }
        }
    });
    
    IMP originalForwardingIMP = class_replaceMethod(aClass, @selector(forwardingTargetForSelector:), forwardingIMP, "@@::");
    if (originalForwardingIMP) {
        class_addMethod(aClass, ProxySelector(aClass, @selector(forwardingTargetForSelector:)), originalForwardingIMP, "@@::");
    }
    
    //add forwardInvocation: implementation
    IMP forwardIMP = imp_implementationWithBlock(^(id target, NSInvocation *anInvocation){
        if ([[aClass _ps_aspected_selectors] containsObject:NSStringFromSelector(anInvocation.selector)]) {
            NSArray<id<PSInterceptor>> *interceptors = [PSAspect _interceptors_for_invocation:anInvocation search_from:aClass];
            object_setClass(anInvocation, [PSInvocation class]);
            
            SEL proxySelector = ProxySelector(aClass, anInvocation.selector);
            PSInvocationDetails *details = [PSInvocationDetails detailsWithProxySelector:proxySelector interceptors:interceptors];
            [anInvocation.target _ps_set_details:details for_invocation:anInvocation];
            
            [anInvocation invoke];
        }else{
            SEL proxyForwardingSel = ProxySelector(aClass, @selector(forwardInvocation:));
            if ([aClass instancesRespondToSelector:proxyForwardingSel]) {
                ((void(*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&(struct objc_super){target, aClass}, proxyForwardingSel, anInvocation);
            }else{
                ((void(*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&(struct objc_super){target, [aClass superclass]}, @selector(forwardInvocation:), anInvocation);
            }
        }
    });
    
    IMP originalForwardIMP = class_replaceMethod(aClass, @selector(forwardInvocation:), forwardIMP, "v@:@");
    if (originalForwardIMP) {
        class_addMethod(aClass, ProxySelector(aClass, @selector(forwardInvocation:)), originalForwardIMP, "v@:@");
    }
}

/** get interceptors for invocation. */
+ (NSArray<id<PSInterceptor>> *)_interceptors_for_invocation:(NSInvocation *)invocation search_from:(Class)aClass{
    NSArray<id<PSInterceptor>> *classInterceptors = [aClass _ps_interceptors_for_selector:invocation.selector];
    NSArray<id<PSInterceptor>> *instanceInterceptors = [invocation.target _ps_interceptors_for_selector:invocation.selector];
    
    NSMutableArray *result = [NSMutableArray new];
    
    doIf(classInterceptors.count, [result addObjectsFromArray:classInterceptors]);
    doIf(instanceInterceptors.count, [result addObjectsFromArray:instanceInterceptors]);
    
    return result;
}

@end

@implementation PSAspect (Class)
+ (void)interceptSelector:(SEL)aSelector inClass:(Class)aClass withInterceptor:(id<PSInterceptor>)aInterceptor{
    NSParameterAssert(aSelector);
    NSParameterAssert(aClass);
    NSParameterAssert(aInterceptor);
    PSAssert([aClass instancesRespondToSelector:aSelector], @"PSAspect can not complete: Instance of <%@> does not respond to selector:%@", NSStringFromClass(aClass), NSStringFromSelector(aSelector));
    
    [self _proxy_selector:aSelector in_class:aClass];
    
    [(id)aInterceptor _ps_set_aspect_target:aClass];
    [[aClass _ps_interceptors_for_selector:aSelector] addObject:aInterceptor];
}

+ (void)clearInterceptorsForClass:(Class)aClass{
    [aClass _ps_clear_all_interceptors];
}

+ (void)clearInterceptsForSelector:(SEL)aSelector inClass:(Class)aClass{
    [[aClass _ps_interceptors_for_selector:aSelector] removeAllObjects];
}
@end


@implementation PSAspect (Instance)
+ (void)interceptSelector:(SEL)aSelector inInstance:(id)aInstance withInterceptor:(id<PSInterceptor>)aInterceptor{
    NSParameterAssert(aSelector);
    NSParameterAssert(aInterceptor);
    NSParameterAssert(aInterceptor);
    PSAssert([aInstance respondsToSelector:aSelector], @"PSAspect can not complete: Instance:<%@ %p> does not respond to selector:%@",NSStringFromClass(aInterceptor.class), aInstance, NSStringFromSelector(aSelector));
    
    [self _proxy_selector:aSelector in_class:[aInstance class]];
    
    [(id)aInterceptor _ps_set_aspect_target:[aInstance class]];
    [[[aInstance _ps_aspect_map] ps_objectForKey:NSStringFromSelector(aSelector)
                                      setDefault:^{return [NSMutableArray new];}] addObject:aInterceptor];
}
@end

#pragma mark - PSAspect Associated Info
@implementation NSObject (PSAspect_Associated_Info)
#pragma mark - instance interceptors
- (NSMutableDictionary<NSString *,NSMutableArray<id<PSInterceptor>> *> *)_ps_aspect_map{
    PSAssociatedKeyAndNotes(OBJECT_ASPECT_MAP_KEY, "Store Selector-Interceptors Map");
    return [self ps_associatedObjectForKey:OBJECT_ASPECT_MAP_KEY storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id{return [NSMutableDictionary new];}];
}

- (NSArray<id<PSInterceptor>> *)_ps_interceptors_for_selector:(SEL)aSelector{
    return [[self _ps_aspect_map] objectForKey:NSStringFromSelector(aSelector)];
}

#pragma mark - class interceptors
PSAssociatedKeyAndNotes(PS_INTERCEPTORS_FOR_SELECTOR_IN_OWN, "Store Interceptors for selector");
+ (NSMutableArray<id<PSInterceptor>> *)_ps_interceptors_for_selector:(SEL)aSelector{
    return [[self ps_associatedObjectForKey:PS_INTERCEPTORS_FOR_SELECTOR_IN_OWN storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id _Nonnull{
        return [NSMutableDictionary new];
    }] ps_objectForKey:NSStringFromSelector(aSelector) setDefault:^id _Nonnull{
        return [NSMutableArray new];
    }];
}

+ (void)_ps_clear_all_interceptors{
    [self ps_setAssociatedObject:[NSMutableDictionary new] forKey:PS_INTERCEPTORS_FOR_SELECTOR_IN_OWN];
}

#pragma mark - utils implementation
+ (NSMutableSet<NSString *> *)_ps_aspected_selectors{
    PSAssociatedKeyAndNotes(PS_ASPECTED_SELECTOR_KEY, "Store selectors that aspected");
    return [self ps_associatedObjectForKey:PS_ASPECTED_SELECTOR_KEY storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id _Nonnull{
        return [NSMutableSet new];
    }];
}
@end

@implementation NSObject (PSAspect)
- (void)ps_interceptSelector:(SEL)aSelector withInterceptor:(id<PSInterceptor>)aInterceptor{
    [PSAspect interceptSelector:aSelector inInstance:self withInterceptor:aInterceptor];
}

+ (void)ps_interceptSelector:(SEL)aSelector withInterceptor:(id<PSInterceptor>)aInterceptor{
    [PSAspect interceptSelector:aSelector inClass:[self class] withInterceptor:aInterceptor];
}
@end

#pragma mark - PSBlockInterceptor
@interface PSBlockInterceptor : NSObject<PSInterceptor>
@property (nonatomic, copy) void (^interceptor)(NSInvocation *invocation);
+ (instancetype)interceptorWithBlock:(void (^)(NSInvocation *invocation))block;
@end

@implementation PSBlockInterceptor
+ (instancetype)interceptorWithBlock:(void (^)(NSInvocation *))block{
    PSBlockInterceptor *instance = [self new];
    instance.interceptor = block;
    return instance;
}
- (void)intercept:(NSInvocation *)invocation{
    doIf(self.interceptor, self.interceptor(invocation));
}
@end

id<PSInterceptor> interceptor(void (^block)(NSInvocation *invocation)){
    return [PSBlockInterceptor interceptorWithBlock:block];
}
