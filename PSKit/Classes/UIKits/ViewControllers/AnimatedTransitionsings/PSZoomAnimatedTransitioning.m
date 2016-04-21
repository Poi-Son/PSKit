//
//  MDZoomAnimation.m
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSZoomAnimatedTransitioning.h"

@implementation PSZoomAnimatedTransitioning{
    CGRect _fromFrame;
    CGRect _toFrame;
}
+ (instancetype)animationFromFrame:(CGRect)frame{
    return [[PSZoomAnimatedTransitioning alloc] initWithFromFrame:frame];
}

- (instancetype)initWithFromFrame:(CGRect)frame{
    if (self = [super init]) {
        _fromFrame = frame;
        _toFrame = CGRectZero;
        self.duration = 0.4f;
    }
    return self;
}

+ (instancetype)animationToFrame:(CGRect)frame{
    return [[PSZoomAnimatedTransitioning alloc] initWithToFrame:frame];
}

- (instancetype)initWithToFrame:(CGRect)frame{
    if (self = [super init]) {
        _fromFrame = CGRectZero;
        _toFrame = frame;
        self.duration = 0.4f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!CGRectEqualToRect(CGRectZero, _fromFrame)) {
        [self animateForPushContext:transitionContext
                 fromViewController:fromViewController
                   toViewController:toViewController];
    }else{
        [self animateForPopContext:transitionContext
                fromViewController:fromViewController
                  toViewController:toViewController];
    }
}

//Push
- (void)animateForPushContext:(id<UIViewControllerContextTransitioning>)transitionContext
           fromViewController:(UIViewController *)fromViewController
             toViewController:(UIViewController *)toViewController{

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    
    CGRect finalFrame = toViewController.view.frame;
    
    toViewController.view.alpha = 0;
    
    
    
    toViewController.view.transform = CGAffineTransformScale(toViewController.view.transform, _fromFrame.size.width / toViewController.view.frame.size.width, _fromFrame.size.height / toViewController.view.frame.size.height);
    
    toViewController.view.frame = (CGRect){_fromFrame.origin, toViewController.view.frame.size};
    toViewController.view.userInteractionEnabled = NO;
    fromViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.alpha = 1;
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         toViewController.view.userInteractionEnabled = YES;
                         fromViewController.view.userInteractionEnabled = YES;
                     }];
}
//Pop
- (void)animateForPopContext:(id<UIViewControllerContextTransitioning>)transitionContext
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController{
    
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    toViewController.view.userInteractionEnabled = NO;
    fromViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromViewController.view.alpha = 0;
                         fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, _toFrame.size.width / toViewController.view.frame.size.width, _toFrame.size.height / toViewController.view.frame.size.height);
                         fromViewController.view.frame = _toFrame;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         fromViewController.view.frame = toViewController.view.frame;
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         fromViewController.view.alpha = 1;
                     }];
}
@end
