//
//  dispatch.m
//  PSKit
//
//  Created by PoiSon on 15/12/29.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "NSObject_Dispatch.h"
#import "PSFoudation.h"
#import <libkern/OSAtomic.h>


@implementation NSObject (PSDispatch)
- (void)ps_performBlockSync:(dispatch_block)block{
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)ps_performBlockSync:(dispatch_block)block afterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(ps_performBlockSync:) withObject:block afterDelay:delay];
}

- (void)ps_performBlockAsync:(dispatch_block)block{
    [self _ps_execute_block:block on_queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completion:nil];
}

- (void)ps_performBlockAsync:(dispatch_block)block completion:(dispatch_block)completion{
    [self _ps_execute_block:block on_queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completion:nil];
}

- (void)ps_performBlockOnNewThread:(dispatch_block)block{
    [self _ps_execute_block:block on_queue:dispatch_queue_create([[@"PS_ASYNC_THREAD_" stringByAppendingString:[NSString ps_randomStringWithLenght:8]] UTF8String], NULL) completion:nil];
}

- (void)ps_performBlockOnNewThread:(dispatch_block)block completion:(dispatch_block)completion{
    [self _ps_execute_block:block on_queue:dispatch_queue_create([[@"PS_ASYNC_THREAD_" stringByAppendingString:[NSString ps_randomStringWithLenght:8]] UTF8String], NULL) completion:completion];
}

- (void)_ps_execute_block:(dispatch_block)block on_queue:(dispatch_queue_t)queue completion:(dispatch_block)completion{
    dispatch_async(queue, ^{
        block();
        doIf(completion, [self ps_performBlockSync:completion]);
    });
}

- (void)ps_performBlockLocked:(dispatch_block)block{
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}
@end