//
//  NSDate+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDateFormatter(CacheKit)
/* 由于创建Formatter是一个耗时操作, 因此将它缓存起来 */
+ (NSDateFormatter *)ps_formatterFromCache:(NSString *)format;
@end

@interface NSDate (Kit)
- (NSDate *)ps_dateByAddingDays:(NSInteger)days;
- (NSString *)ps_toString;/**< yyyy-MM-dd HH:mm:ss */
- (NSString *)ps_toString:(NSString *)format;

- (BOOL)ps_isLaterThan:(NSDate *)date;/**< 是否比${date}更早 */
- (BOOL)ps_isEarlierThan:(NSDate *)date;/**< 是否比${date}更晚 */

- (NSString *)ps_weakdayStr;/**< 返回当前日期 "星期X" */
@end

@interface NSString (PSDateExtensionMethods)
- (NSDate *)ps_dateValue:(NSString *)format;/**< 格式化日期字符串. */
@end
NS_ASSUME_NONNULL_END