//
//  dispatch.h
//  PSKit
//
//  Created by PoiSon on 15/12/29.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^dispatch_block)(void);
NS_ASSUME_NONNULL_BEGIN
/****************************************************************************
 *  BlockPerform
 ****************************************************************************/
@interface NSObject (PSDispatch)
- (void)ps_performBlockSync:(dispatch_block)block;/**< 主线程执行Block. */
- (void)ps_performBlockSync:(dispatch_block)block afterDelay:(NSTimeInterval)delay;/**< 延迟主线程执行Block. */

- (void)ps_performBlockAsync:(dispatch_block)block;/**< 异步执行Block. */
- (void)ps_performBlockAsync:(dispatch_block)block completion:(nullable dispatch_block)completion;/**< 异步执行Block, 任务完成后同步执行completion */

- (void)ps_performBlockOnNewThread:(dispatch_block)block;/**< 开启新线程执行Block */
- (void)ps_performBlockOnNewThread:(dispatch_block)block completion:(nullable dispatch_block)completion;/**< 开启新线程执行Block, 任务完成后同步执行completion */

- (void)ps_performBlockLocked:(dispatch_block)block;/**< 使用锁执行任务 */@end
NS_ASSUME_NONNULL_END