//
//  MDFadeAnimation.m
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFadeAnimatedTransitioning.h"
#import "PSAnimation.h"

@implementation PSFadeAnimatedTransitioning{
    NSTimeInterval _duration;
}
- (instancetype)init{
    return [self initWithDuration:0.4f];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration{
    if (self = [super init]) {
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    PSAnimation.before(^{
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toViewController.view];
        
        toViewController.view.alpha = 0.8;
        toViewController.view.userInteractionEnabled = NO;
        fromViewController.view.userInteractionEnabled = NO;
    }).begin([self transitionDuration:transitionContext], ^{
        toViewController.view.alpha = 1;
        fromViewController.view.alpha = 0;
    }).final(^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromViewController.view.alpha = 1;
        toViewController.view.userInteractionEnabled = YES;
        fromViewController.view.userInteractionEnabled = YES;
    });
}
@end
