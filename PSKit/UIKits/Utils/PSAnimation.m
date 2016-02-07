//
//  PSAnimationAction.m
//  PSKit
//
//  Created by PoiSon on 15/11/26.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSAnimation.h"
#import "PSFoudation.h"

@interface PSAnimateAction : NSObject
@property (nonatomic, copy) void (^action)();
@property (nonatomic, assign) NSTimeInterval duration;
@end

@interface PSAnimation ()
@property (nonatomic, copy) void(^beforeAction)();
@property (nonatomic, copy) void(^finalAction)();
@property (nonatomic, strong, readonly) NSMutableArray<PSAnimateAction *> *actions;

@end

@implementation PSAnimation

- (NSMutableSet<PSAnimation*> *)holder{
    static NSMutableSet<PSAnimation*> *holder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        holder = [NSMutableSet new];
    });
    return holder;
}

- (instancetype)init{
    if (self = [super init]) {
        _actions = [NSMutableArray new];
    }
    return self;
}

+ (PSAnimation *(^)(void (^)()))before{
    return ^(void(^action)()){
        PSAnimation *animation = [PSAnimation new];
        animation.beforeAction = action;
        return animation;
    };
}

+ (PSAnimation *(^)(NSTimeInterval, void (^)()))begin{
    return ^(NSTimeInterval duration, void(^action)()){
        PSAnimateAction *animateAction = [PSAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        
        PSAnimation *animation = [PSAnimation new];
        [animation.actions addObject:animateAction];
        return animation;
    };
}

- (PSAnimation *(^)(void (^)()))before{
    return ^(void(^action)()){
        self.beforeAction = action;
        return self;
    };
}

- (PSAnimation *(^)(NSTimeInterval, void (^)()))begin{
    return ^(NSTimeInterval duration, void(^action)()){
        PSAnimateAction *animateAction = [PSAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        
        [self.actions addObject:animateAction];
        return self;
    };
}

- (PSAnimation *(^)(NSTimeInterval))delay{
    return ^(NSTimeInterval delay){
        PSAnimateAction *animateAction = [PSAnimateAction new];
        animateAction.action = nil;
        animateAction.duration = delay;
        [_actions addObject:animateAction];
        return self;
    };
}

- (PSAnimation *(^)(NSTimeInterval, void (^)()))then{
    return ^(NSTimeInterval duration, void(^action)()){
        PSAnimateAction *animateAction = [PSAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        [_actions addObject:animateAction];
        return self;
    };
}

- (PSAnimation *(^)(void (^)()))final{
    return ^(void(^action)()){
        self.finalAction = action;
        return self;
    };
}

- (void)action{
    doIf(self.beforeAction, self.beforeAction());
    [self.holder addObject:self];
    [self actWithActions:_actions];
}

- (void)actWithActions:(NSMutableArray<PSAnimateAction *> *)actions{
    PSAnimateAction *action = [actions ps_removeFirstObject];
    
    if (!action) {
        doIf(self.finalAction, self.finalAction());
        [self.holder removeObject:self];
        return;
    }
    
    if (action.action) {
        [UIView animateWithDuration:action.duration
                         animations:^{
                             action.action();
                         } completion:^(BOOL finished) {
                             [self actWithActions:actions];
                         }];
    }else{
        [self ps_performBlockSync:^{
            [self actWithActions:actions];
        } afterDelay:action.duration];
    }
    
}
@end

@implementation PSAnimateAction

@end
