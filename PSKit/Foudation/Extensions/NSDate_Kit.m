//
//  NSDate+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "NSDate_Kit.h"
#import "PSFoudation.h"

@implementation NSDateFormatter (CacheKit)
static NSMutableDictionary<NSString *, NSDateFormatter *> *ps_formatter_cache;

+ (NSDateFormatter *)ps_formatterFromCache:(NSString *)format{
    if (!ps_formatter_cache) {
        ps_formatter_cache = [NSMutableDictionary new];
    }
    return [ps_formatter_cache ps_objectForKey:format
                                    setDefault:^NSDateFormatter * _Nonnull{
                                        NSDateFormatter *newFormatter = [NSDateFormatter new];
                                        newFormatter.dateFormat = format;
                                        return newFormatter;
                                    }];
}

@end

@implementation NSDate (Kit)

- (NSDate *)ps_dateByAddingDays:(NSInteger)days{
    return [self dateByAddingTimeInterval:24 * 60 * 60 * days];
}

- (NSString *)ps_toString{
    return [self ps_toString:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)ps_toString:(NSString *)format{
    return [[NSDateFormatter ps_formatterFromCache:format] stringFromDate:self];
}

- (BOOL)ps_isEarlierThan:(NSDate *)date{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)ps_isLaterThan:(NSDate *)date{
    return [self compare:date] == NSOrderedDescending;
}

- (NSString *)ps_weakdayStr{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger uniFlags = NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:uniFlags fromDate:self];
    switch (comps.weekday) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
    }
    return @"星期六";
}
@end

@implementation NSString(PSDateExtensionMethods)
- (NSDate *)ps_dateValue:(NSString *)format{
    return [[NSDateFormatter ps_formatterFromCache:format] dateFromString:self];
}
@end
