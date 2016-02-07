//
//  NSNull+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/11/10.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Null safe
 *  如果启用Null save, 那么向[NSNull null]发送消息与向nil发送消息的效果相同, 即不会崩溃
 */
@interface NSNull (Safe)
/** 是否启用安全策略 */
+ (void)ps_setNullSafeEnabled:(BOOL)enabled;
@end
