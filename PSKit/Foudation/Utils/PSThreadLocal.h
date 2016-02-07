//
//  PSThreadLocal.h
//  PSKit
//
//  Created by PoiSon on 15/10/11.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PSThreadLocal<ObjectType>;
@protocol PSThreadLocalSupplier <NSObject>
@required

- (nullable id)initialValueForthreadLocal:(PSThreadLocal *)threadLocal;/**< provide initial value. */
@end

/**
 *  This class provides thread-local variables. 
 *  <p>Each thread holds an implicit refernce to its copy of a thread-local variable as long
 *  as the thread is alive and the instance is accessible; After a thread gose away, all of
 *  its copies of thread-local instances will release (unless ohter refernce to these copies
 *  exists).
 */
@interface PSThreadLocal<ObjectType> : NSObject
@property (nullable, nonatomic, strong) ObjectType value;/**< thread local value. */
- (void)remove;/**< clear thread local value. */

- (instancetype)initWithSupplier:(id<PSThreadLocalSupplier>)supplier;
@end
NS_ASSUME_NONNULL_END