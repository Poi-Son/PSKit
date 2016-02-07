//
//  NSDictionary+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary<KeyType, ObjectType> (Kit)
- (nullable ObjectType)ps_objectForKey:(KeyType)key useDefault:(ObjectType (^)())defaultValue;/**< 获取object，如果没有返回defaultValue. */
- (BOOL)ps_containsKey:(KeyType)key;/**< 判断是否包含Key */
@end

@interface NSMutableDictionary<KeyType, ObjectType> (Kit)
- (ObjectType)ps_objectForKey:(KeyType)key setDefault:(ObjectType (^)())defaultValue;/**< 获取object，如果没有，添加并返回defaultValue. */
@end

NS_ASSUME_NONNULL_END