//
//  NSMutableArray+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSArray<ObjectType> (PSSearch)
- (NSArray<ObjectType> *)ps_arrayWithCondition:(BOOL (^)(ObjectType obj))condition;/**< 筛选符合条件的 */
- (NSArray<ObjectType> *)ps_removeWithCondition:(BOOL (^)(ObjectType obj))condition;/**< 删除符合条件的 */
- (NSArray<ObjectType> *)ps_arrayInArray:(NSArray<ObjectType> *)array;/**< 筛选两个数组中相同的元素 */
@end

@interface NSArray<ObjectType>(Kit)
- (NSArray<ObjectType> *)ps_objectsBeforIndex:(NSUInteger)index;/**< 取前几个元素. */
- (NSArray<ObjectType> *)ps_objectsAfterIndex:(NSUInteger)index;/**< 取后几个元素. */
- (NSArray<ObjectType> *)ps_objectsInRange:(NSRange)range;/**< 取出范围内的元素. */

- (instancetype)reverse;/**< 元素倒序 */

- (NSString *)ps_join:(NSString *)separator;/**< 将元素拼接成字符串，使用${separator}分割 */

- (NSSet *)ps_toSet;/**< 转换成NSSet */
- (NSMutableSet *)ps_toMutableSet;/**< 转换成NSMutableSet */

- (instancetype)ps_initWithEnumerator:(NSEnumerator *)enumerator;/**< 使用Enumerator初始化 */
+ (instancetype)ps_arrayWithEnumerator:(NSEnumerator *)enumerator;/**< 使用Enumerator初始化 */
@end

@interface NSMutableArray<ObjectType> (Kit)
- (void)ps_removeObjectsFormArray:(NSArray<ObjectType> *)array;/**< 移除array中的元素. */
- (void)ps_replaceObject:(ObjectType)obj withObjec:(ObjectType)anotherObj;/**< 替换元素. */
- (void)ps_moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;/**< 将fromIndex上的元素移至toIndex. */

- (void)ps_insertObjectAtFirst:(ObjectType)obj;/**< 向头部插入一个元素. */
- (void)ps_insertObjectsAtFirst:(NSArray<ObjectType> *)array;/**< 向头部插入一个数组. */

- (nullable ObjectType)ps_removeFirstObject;/**< 移除第一个元素，并返回它. */
- (NSArray<ObjectType> *)ps_removeFirstObjects:(NSUInteger)count;/**< 移除前几个元素，并返回它们. */

- (void)ps_addObject:(ObjectType)obj;/**< 添加一个元素(尾部). */
- (void)ps_addObjects:(NSArray<ObjectType> *)array;/**< 添加一个数组(尾部). */
- (nullable ObjectType)ps_removeLastObject;/**< 移除最后一个元素. */
- (NSArray<ObjectType> *)ps_removeLastObjects:(NSUInteger)count;/**< 移除最后几个元素. */

- (void)ps_addObjectsFormEnumerator:(NSEnumerator *)enumerator;/**< 添加Enumerator下的元素 */
@end
NS_ASSUME_NONNULL_END