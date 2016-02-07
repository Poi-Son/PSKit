//
//  PSDelayInvocation.m
//  PSKit
//
//  Created by PoiSon on 16/1/14.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import "PSDelayInvocation.h"
#import "PSFoudation.h"

@interface PSDelayProxy : NSProxy
@property (nonatomic, strong) id target;
@property (nonatomic, copy) void (^recordCompleted)(NSInvocation *invocation);
@end

@implementation PSDelayInvocation{
    PSDelayProxy *_proxy;
    NSMutableArray<NSInvocation *> *_stack;
}

- (void)exeInvocation{
    static NSTimeInterval lastExeTime = 0;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - lastExeTime < self.delay) {
        [self.class cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(exeInvocation) withObject:nil afterDelay:self.delay];
        return;
    }
    lastExeTime = now;
    
    NSInvocation *invocation = [self.stack lastObject];
    [self.stack removeAllObjects];
    
    if (invocation != nil) {
        [invocation invoke];
    }
}

- (NSMutableArray<NSInvocation *> *)stack{
    return _stack ?: (_stack = [NSMutableArray new]);
}

- (PSDelayProxy *)proxy{
    return _proxy ?: ({
        _proxy = [PSDelayProxy alloc];
        weak(self);
        [_proxy setRecordCompleted:^(NSInvocation *invocation) {
            strong(self);
            [self.stack addObject:invocation];
            [self exeInvocation];
        }];
        _proxy;
    });
}

- (id)prepareWithTarget:(id)target{
    self.proxy.target = target;
    return self.proxy;
}
@end


@implementation PSDelayProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    if (self.recordCompleted) {
        invocation.target = self.target;
        if (!invocation.argumentsRetained) {
            [invocation retainArguments];
        }
        self.recordCompleted(invocation);
    }
}
@end