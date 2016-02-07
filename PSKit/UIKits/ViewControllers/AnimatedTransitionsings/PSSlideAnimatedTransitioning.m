//
//  SlideAnimation.m
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSSlideAnimatedTransitioning.h"

@interface PSSlideAnimatedTransitioning()
@property (nonatomic, assign) PSSlideTransitioningDirection direction;
@property (nonatomic, assign) BOOL isPop;
@end


@implementation PSSlideAnimatedTransitioning

+ (instancetype)animationWithSlideDirection:(PSSlideTransitioningDirection)direction isPop:(BOOL)isPop{
    return [[PSSlideAnimatedTransitioning alloc] initWithSlideDirection:direction isPop:isPop];
}

+ (instancetype)animationWithSlideDirection:(PSSlideTransitioningDirection)direction{
    return [[PSSlideAnimatedTransitioning alloc] initWithSlideDirection:direction isPop:NO];
}

- (instancetype)initWithSlideDirection:(PSSlideTransitioningDirection)direction isPop:(BOOL)isPop{
    if (self = [super init]) {
        self.direction = direction;
        self.isPop = isPop;
        self.duration = 0.4f;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPop) {
        [self animateForPopContext:transitionContext fromViewController:fromVC toViewController:toVC];
    }else{
        [self animateForPushContext:transitionContext fromViewController:fromVC toViewController:toVC];
    }
    
}
//Push
- (void)animateForPushContext:(id<UIViewControllerContextTransitioning>)transitionContext
           fromViewController:(UIViewController *)fromViewController
             toViewController:(UIViewController *)toViewController{
    
    CGRect finalFrame = toViewController.view.frame;
    
    CGRect origenFrame = CGRectZero;
    
    switch (self.direction) {
        case PSSlideTransitioningToLeft:
            origenFrame = (CGRect){CGPointMake(finalFrame.size.width, 0), finalFrame.size};
            break;
        case PSSlideTransitioningToRight:
            origenFrame = (CGRect){CGPointMake(- finalFrame.size.width, 0), finalFrame.size};
            break;
        case PSSlideTransitioningToTop:
            origenFrame = (CGRect){CGPointMake(0, - finalFrame.size.height), finalFrame.size};
            break;
        case PSSlideTransitioningToBottom:
            origenFrame = (CGRect){CGPointMake(0, finalFrame.size.height), finalFrame.size};
            break;
    }
    
    toViewController.view.frame = origenFrame;
    
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    
    toViewController.view.userInteractionEnabled = NO;
    fromViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
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
    
    CGRect finalFrame = fromViewController.view.frame;
    
    switch (self.direction) {
        case PSSlideTransitioningToLeft:
            finalFrame = (CGRect){CGPointMake(finalFrame.size.width, 0), finalFrame.size};
            break;
        case PSSlideTransitioningToRight:
            finalFrame = (CGRect){CGPointMake(- finalFrame.size.width, 0), finalFrame.size};
            break;
        case PSSlideTransitioningToTop:
            finalFrame = (CGRect){CGPointMake(0, finalFrame.size.height), finalFrame.size};
            break;
        case PSSlideTransitioningToBottom:
            finalFrame = (CGRect){CGPointMake(0, - finalFrame.size.height), finalFrame.size};
            break;
    }
    
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    toViewController.view.userInteractionEnabled = NO;
    fromViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         toViewController.view.userInteractionEnabled = YES;
                         fromViewController.view.userInteractionEnabled = YES;
                     }];
}

@end
