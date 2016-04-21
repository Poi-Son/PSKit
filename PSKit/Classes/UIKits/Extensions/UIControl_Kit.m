//
//  UIControl+Handler.m
//  PSKit
//
//  Created by PoiSon on 15/9/18.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "UIControl_Kit.h"
#import "PSFoudation.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define PS_EVENT_SEP @"__ps_event__"

@implementation UIControl (PSKit)
- (void (^)(UIControlEvents, id))ps_on{
    return ^(UIControlEvents event, id handler){
        [self ps_addHandler:^(__strong id sender, UIControlEvents events, UIEvent *event) {
            PSBlockInvocation *invocation = [PSBlockInvocation invocationWithBlock:handler];
            
            NSUInteger argCount = invocation.methodSignature.numberOfArguments;
            
            if (argCount > 1) {
                [invocation setArgument:&sender atIndex:1];
            }
            if (argCount > 2) {
                [invocation setArgument:&event atIndex:2];
            }
            
            [invocation invoke];
        } forEvent:event];
    };
}

- (void (^)(UIControlEvents))off{
    return ^(UIControlEvents events){
        [self ps_clearHandlersForEvents:events];
    };
}

/**
 *  保存Handlers的实例
 */
- (NSMutableDictionary<NSNumber/*UIControlEvents*/*, NSMutableArray<PSEventHandler> *> *)_ps_operations{
    PSAssociatedKeyAndNotes(PS_OPERATION_KEY, "保存Handlers的实例");
    return [self ps_associatedObjectForKey:PS_OPERATION_KEY storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id{
        return [NSMutableDictionary new];
    }];
}

/**
 *  保存Handler
 */
- (void)ps_addHandler:(PSEventHandler)handler forEvent:(UIControlEvents)event{
    NSMutableArray<PSEventHandler> *handlers = [self._ps_operations objectForKey:@(event)];
    if (!handlers) {
        handlers = [NSMutableArray new];
    }
    [handlers addObject:[handler copy]];
    [self._ps_operations setObject:handlers forKey:@(event)];
}

/**
 *  删除某事件的所有Handler
 */
- (void)ps_clearHandlersForEvents:(UIControlEvents)controlEvents{
    NSArray<NSNumber *> *events = self.class._ps_events;
    for (NSInteger i = 0; i < events.count; i ++) {
        UIControlEvents obj = [events[i] integerValue];
        if ((obj & controlEvents) == obj) {
            [[self _ps_operations] removeObjectForKey:@(obj)];
            [self removeTarget:self action:NSSelectorFromString(NSStringWithFormat(@"%@%@sender:forEvent:", @(obj), PS_EVENT_SEP)) forControlEvents:obj];
        }
    }
}

/**
 *  添加某事件的处理方法
 */
- (void)ps_addHandler:(PSEventHandler)handler forControlEvents:(UIControlEvents)controlEvents{
    NSArray<NSNumber *> *events = self.class._ps_events;
    for (NSUInteger i = 0; i < events.count; i ++) {
        UIControlEvents obj = [events[i] integerValue];
        if ((obj & controlEvents) == obj) {
            [self addTarget:self action:NSSelectorFromString(NSStringWithFormat(@"%@%@sender:forEvent:", @(obj), PS_EVENT_SEP)) forControlEvents:obj];
            [self ps_addHandler:handler forEvent:obj];
        }
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) ps_containsString:PS_EVENT_SEP]) {
        return class_addMethod(self, sel, (IMP)_objc_msgForward, "v@:@@");
    }
    return [super resolveInstanceMethod:sel];
}

/**
 *  处理事件
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([self _ps_is_event_method:anInvocation.selector]) {
        UIControlEvents events = [self _ps_getEventFromSelector:anInvocation.selector];
        __unsafe_unretained UIEvent *event;
        [anInvocation getArgument:&event atIndex:3];
        
        NSArray *handlers = [self._ps_operations objectForKey:@(events)];
        for (PSEventHandler handler in handlers) {
            handler(self, events, event);
        }
    }else{
        [super forwardInvocation:anInvocation];
    }
}

/**
 *  判断某个selector是否是事件处理函数
 */
- (BOOL)_ps_is_event_method:(SEL)aSelector{
    return [[self.class _ps_events] containsObject:@([self _ps_getEventFromSelector:aSelector])];
}

/**
 *  提取selector中的事件名称
 */
- (UIControlEvents)_ps_getEventFromSelector:(SEL)aSelector{
    NSString *selectorStr = NSStringFromSelector(aSelector);
    if ([selectorStr containsString:PS_EVENT_SEP]) {
        return [[[selectorStr componentsSeparatedByString:PS_EVENT_SEP] objectAtIndex:0] integerValue];
    }
    return 0;
}

/**
 *  事件列表
 */
+ (NSArray<NSNumber *> *)_ps_events{
    static NSArray<NSNumber *> *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@(UIControlEventTouchDown),
                  @(UIControlEventTouchDownRepeat),
                  @(UIControlEventTouchDragInside),
                  @(UIControlEventTouchDragOutside),
                  @(UIControlEventTouchDragEnter),
                  @(UIControlEventTouchDragExit),
                  @(UIControlEventTouchUpInside),
                  @(UIControlEventTouchUpOutside),
                  @(UIControlEventTouchCancel),
                  @(UIControlEventValueChanged),
                  @(UIControlEventEditingDidBegin),
                  @(UIControlEventEditingChanged),
                  @(UIControlEventEditingDidEnd),
                  @(UIControlEventEditingDidEndOnExit),
                  @(UIControlEventAllTouchEvents),
                  @(UIControlEventAllEditingEvents),
                  @(UIControlEventApplicationReserved),
                  @(UIControlEventSystemReserved),
                  @(UIControlEventAllEvents)
                  ];
    });
    return array;
}
@end
