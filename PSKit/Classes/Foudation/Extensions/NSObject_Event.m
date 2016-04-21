//
//  NSObject+Event.m
//  PSKit
//
//  Created by PoiSon on 15/9/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"
#import <objc/message.h>

@interface PSEventReceiver : NSObject
@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id sender;
@property (nonatomic) SEL selector;
+ (instancetype)receiverWithObj:(id)receiver sender:(id)sender selector:(SEL)aSelector;
@end

@interface PSEventRegister : NSObject
+ (void)registerObserver:(id)observer selector:(SEL)aSelector sender:(id)sender forEvent:(NSString *)event priority:(PSEventPriority)priority;
+ (void)dispatchEvent:(NSString *)event withSender:(id)sender userinfo:(NSDictionary *)info;
@end


@interface PSEvent()
+ (instancetype)eventForSender:(id)sender event:(NSString *)name userInfo:(NSDictionary *)userInfo;
@end

@implementation NSObject (PSEvent)
- (void)ps_registEvent:(NSString *)name selector:(SEL)aSelector sender:(id)sender{
    [PSEventRegister registerObserver:self selector:aSelector sender:sender forEvent:name priority:PSEventPriorityNormal];
}

- (void)ps_registEvent:(NSString *)name selector:(SEL)aSelector sender:(id)sender priority:(PSEventPriority)priority{
    [PSEventRegister registerObserver:self selector:aSelector sender:sender forEvent:name priority:priority];
}

- (void)ps_dispatchEvent:(NSString *)name withUserInfo:(NSDictionary *)info{
    [PSEventRegister dispatchEvent:name withSender:self userinfo:info];
}
@end

@implementation PSEventRegister
static NSMutableSet<PSEventReceiver *> *receiverHolder(){
    static NSMutableSet<PSEventReceiver *> *receivers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        receivers = [NSMutableSet new];
    });
    return receivers;
}
static NSHashTable<PSEventReceiver *> *hightReceiver(NSString *event){
    static NSMutableDictionary <NSString *, NSHashTable<PSEventReceiver *> *> *receiver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        receiver = [NSMutableDictionary new];
    });
    return [receiver ps_objectForKey:event setDefault:^NSHashTable<PSEventReceiver *> * _Nonnull{
        return [NSHashTable weakObjectsHashTable];
    }];
}
static NSHashTable<PSEventReceiver *> *normalReceiver(NSString *event){
    static NSMutableDictionary <NSString *, NSHashTable<PSEventReceiver *> *> *receiver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        receiver = [NSMutableDictionary new];
    });
    return [receiver ps_objectForKey:event setDefault:^NSHashTable<PSEventReceiver *> * _Nonnull{
        return [NSHashTable weakObjectsHashTable];
    }];
}
static NSHashTable<PSEventReceiver *> *lowReceiver(NSString *event){
    static NSMutableDictionary <NSString *, NSHashTable<PSEventReceiver *> *> *receiver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        receiver = [NSMutableDictionary new];
    });
    return [receiver ps_objectForKey:event setDefault:^NSHashTable<PSEventReceiver *> * _Nonnull{
        return [NSHashTable weakObjectsHashTable];
    }];
}

+ (void)registerObserver:(id)observer selector:(SEL)aSelector sender:(id)sender forEvent:(NSString *)event priority:(PSEventPriority)priority{
    PSEventReceiver *receiver = [PSEventReceiver receiverWithObj:observer sender:sender selector:aSelector];
    if (priority == PSEventPriorityNormal) {
        [normalReceiver(event) addObject:receiver];
    }else if (priority < PSEventPriorityNormal){
        [hightReceiver(event) addObject:receiver];
    }else{
        [lowReceiver(event) addObject:receiver];
    }
    [receiverHolder() addObject:receiver];
    
    [observer ps_notificateWhenDealloc:^{
        [receiverHolder() removeObject:receiver];
    }];
    
    if (sender) {
        [sender ps_notificateWhenDealloc:^{
            [receiverHolder() removeObject:receiver];
        }];
    }
}


+ (void)dispatchEvent:(NSString *)name withSender:(id)sender userinfo:(NSDictionary *)info{
    PSPrintf(@"📢📢PSEvent:<%@ %p> sent an event: %@\n", [sender class], sender, name);
    dispatchEvent(name, sender, info, hightReceiver(name));
    dispatchEvent(name, sender, info, normalReceiver(name));
    dispatchEvent(name, sender, info, lowReceiver(name));
}

static void dispatchEvent(NSString *event, id sender, NSDictionary *userinfo, NSHashTable<PSEventReceiver *> *receivers){
    dispatch_async(dispatch_get_main_queue(), ^{
        for (PSEventReceiver *receiver in receivers) {
            if (receiver.sender == nil || receiver.sender == sender) {
                PSEvent *psevent = [PSEvent eventForSender:sender event:event userInfo:userinfo];
                SuppressPerformSelectorLeakWarning([receiver.receiver performSelector:receiver.selector withObject:psevent]);
            }
        }
    });
}
@end



@implementation PSEvent
+ (instancetype)eventForSender:(id)sender event:(NSString *)name userInfo:(NSDictionary *)userInfo{
    PSEvent *notification = [PSEvent new];
    notification.sender = sender;
    notification.name = name;
    notification.userInfo = userInfo;
    return notification;
}
@end

@implementation PSEventReceiver
+ (instancetype)receiverWithObj:(id)receiver sender:(id)sender selector:(SEL)aSelector{
    PSEventReceiver *obj = [self new];
    obj.receiver = receiver;
    obj.sender = sender;
    obj.selector = aSelector;
    return obj;
}
@end