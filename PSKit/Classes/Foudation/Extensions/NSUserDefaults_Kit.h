//
//  NSUserDefaults+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSUserDefaults (Kit)
- (void)ps_setObject:(id)value forKey:(NSString *)key;/**< 保存键值对(已同步) */
- (id)ps_objectForKey:(NSString *)key setDefault:(id (^)())defaultValue;/**< 获取object，如果没有，添加并返回defaultValue(已同步) */
@end
NS_ASSUME_NONNULL_END
