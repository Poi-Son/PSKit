//
//  NSSet+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/10/24.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSSet<ObjectType> (PSSearch)
- (NSSet<ObjectType> *)ps_setWithCondition:(BOOL (^)(ObjectType obj))condition;/**< 筛选符合条件的 */
- (NSSet<ObjectType> *)ps_removeWithCondition:(BOOL (^)(ObjectType obj))condition;/**< 删除符合条件的 */
- (NSSet<ObjectType> *)ps_setInSet:(NSSet<ObjectType> *)set;/**< 筛选两个Set中相同的元素 */
@end

@interface NSSet<ObjectType> (Kit)
- (NSString *)ps_join:(NSString *)separator; /**< 将元素用${separator}分隔并拼接成字符串. */
- (NSArray *)ps_toArray;/**< 转换成NSArray, 无序 */
- (NSMutableArray *)ps_toMutableArray;/**< 转换成NSMutableArray, 无序 */
@end
NS_ASSUME_NONNULL_END