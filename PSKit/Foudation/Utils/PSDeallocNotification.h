//
//  PSDeallocNotification.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface PSDeallocNotification : NSObject
+ (void)notificateWhenInstanceDelloc:(id)anInstance withCallback:(void (^)(void))callback;
@end
NS_ASSUME_NONNULL_END