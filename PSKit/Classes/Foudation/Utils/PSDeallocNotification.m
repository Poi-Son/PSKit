//
//  PSDeallocNotification.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSDeallocNotification.h"
#import "NSObject_Kit.h"

@interface PSDeallocNotification()
@property (nonatomic, strong) NSMutableArray *callbacks;
@end

@implementation PSDeallocNotification{
    
}
+ (void)notificateWhenInstanceDelloc:(id)anInstance withCallback:(void (^)(void))callback{
    PSAssociatedKeyAndNotes(PS_DEALLOC_NOTIFICATION_KEY, @"Store an object to target, when the target dealloc, this object is dealloc either.");
    PSDeallocNotification *notification = [anInstance ps_associatedObjectForKey:PS_DEALLOC_NOTIFICATION_KEY storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id{
        return [PSDeallocNotification new];
    }];
    [notification.callbacks addObject:callback];
}

- (instancetype)init{
    if (self = [super init]) {
        _callbacks = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc{
    for (id callbackObj in self.callbacks) {
        void (^callback)(void) = (void (^)(void))callbackObj;
        callback();
    }
}
@end
