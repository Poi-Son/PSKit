//
//  NSObject+Runtime.h
//  PSKit
//
//  Created by PoiSon on 15/9/24.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/PSKitDefines.h>

/**
 *  不定参数取值
 *
 *  示例:
 *  - (void)log:(NSString *)format, ...{
 *     va_args(format);
 *     NSString *info = [[NSString alloc] initWithFormat:format arguments:format_args];
 *     NSLog(info, nil);
*   }
 */
#define va_args(arg_start)                     \
      va_list arg_start##_##args;              \
      va_start(arg_start##_##args, arg_start); \
      va_end(arg_start##_##args);


/**
 *  存储策略
 */
typedef NS_ENUM(unsigned long, PSStorePolicy){
    PSKIT_ENUM_OPTION(PSStoreUsingAssign, 0, "weak refernce or assign."),
    PSKIT_ENUM_OPTION(PSStoreUsingRetainNonatomic, 1, "strong refernce and nonatomic."),
    PSKIT_ENUM_OPTION(PSStoreUsingCopyNonatomic, 3, "copied and nonatomic."),
    PSKIT_ENUM_OPTION(PSStoreUsingRetain, 01401, "strong refernce and atomic."),
    PSKIT_ENUM_OPTION(PSStoreUsingCopy, 01403, "copied and atomic.")
};

NS_ASSUME_NONNULL_BEGIN
/****************************************************************************
 *  Runtime
 ****************************************************************************/
#define PSAssociatedKey(key)  static void *key = &key
#define PSAssociatedKeyAndNotes(key, notes) static void *key = &key
@interface NSObject (PSRuntime)
+ (BOOL)ps_isSubclassOfClass:(Class)aClass;/**< 判断是否是否个类的子类 */
- (void)ps_notificateWhenDealloc:(void (^)(void))notification;/**< 当dealloc时，执行${notification}. */

- (void)ps_setAssociatedObject:(id)value forKey:(const void *)key usingProlicy:(PSStorePolicy)policy;/**< 使用associatedObject保存数据. */
- (void)ps_setAssociatedObject:(id)value forKey:(const void *)key;/**< 默认使用PSStoreUsingRetainNonatomic策略保存数据 */
- (id)ps_associatedObjectForKey:(const void *)key;/**< 获取associatedObject数据. */
- (id)ps_associatedObjectForKey:(const void *)key storeProlicy:(PSStorePolicy)policy setDefault:(id (^)(void))defaultValue;/**< 获取associatedObject数据，如果没有，则返回defaultValue，并将defaultValue使用策略保存起来. */

+ (void)ps_setAssociatedObject:(id)value forKey:(const void *)key usingProlicy:(PSStorePolicy)policy;
+ (void)ps_setAssociatedObject:(id)value forKey:(const void *)key;
+ (id)ps_associatedObjectForKey:(const void *)key;
+ (id)ps_associatedObjectForKey:(const void *)key storeProlicy:(PSStorePolicy)policy setDefault:(id  _Nonnull (^)(void))defaultValue;
@end

/****************************************************************************
 *  Block KVO
 *  注意引用循环
 ****************************************************************************/
#define PSKeyPath(...) \
   metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(PSKeyPath1(__VA_ARGS__))(PSKeyPath2(__VA_ARGS__))

#define PSKeyPath1(PATH) \
   @(((void)(NO && ((void)PATH, NO)), strchr(#PATH, '.') + 1))

#define PSKeyPath2(OBJ, PATH)\
   @(((void)(NO && ((void)OBJ.PATH, NO)), #PATH))

@interface NSObject (PSKVO)
- (void)ps_addObserver:(void(^)(id obj, NSDictionary<NSString *, id> *change))callback forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;
- (void)ps_clearObserversForKeyPath:(NSString *)keyPath;
@end

/* 锁定函数, ${delay}大于0时自动延迟解锁, 否则需要调用PSUnlockFunc()解锁*/
#define PSLockFunc(delay) do { [self ps_lockFunc:_cmd unlockDelay:delay]; } while(0)
#define PSUnlockFunc() do { [self ps_unlockFunc:_cmd]; } while(0)
/****************************************************************************
 *  函数锁, 防止短时间执行多次业务逻辑
 *  原理: 当函数被锁时, 该函数的执行对象将被指向nil
 ****************************************************************************/
@interface NSObject (PSFuncLock)
/**
 *  锁定函数
 *
 *  @param selector 目标函数
 *  @param obj      目标函数所在的对象
 *  @param delay    ${delay}大于0时自动延迟解锁, 否则需要手动调用PSUnlockFunc()解锁
 */
- (void)ps_lockFunc:(SEL)selector unlockDelay:(NSTimeInterval)delay;
- (void)ps_unlockFunc:(SEL)selector;/**< 解锁函数 */
@end

/****************************************************************************
 *  Event
 ****************************************************************************/
typedef NS_ENUM(NSInteger, PSEventPriority) {
    PSEventPriorityHigh = 1000, /**< 高优先级, 优先通知 */
    PSEventPriorityNormal = 5000, /**< 普通优先级 */
    PSEventPriorityLow = 10000 /**< 低优先级, 最后通知 */
};

@interface NSObject (PSEvent)
/**
 *  注册事件
 *
 *  @param name      事件名
 *  @param aSelector 回调方法, 第一个参数接收PSNotification对象
 *  @param sender    接收指定事件发送者（如果sender=nil，则接收全部事件）
 */
- (void)ps_registEvent:(NSString *)name selector:(SEL)aSelector sender:(nullable id)sender;
- (void)ps_registEvent:(NSString *)name selector:(SEL)aSelector sender:(nullable id)sender priority:(PSEventPriority)priority;
/**
 *  发送事件
 *
 *  @param name  事件名
 *  @param info  带参
 */
- (void)ps_dispatchEvent:(NSString *)name withUserInfo:(NSDictionary *)info;
@end


@interface PSEvent : NSObject
@property (nonatomic, weak) id sender;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *userInfo;
@end

NS_ASSUME_NONNULL_END
