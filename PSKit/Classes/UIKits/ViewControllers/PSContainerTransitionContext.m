//
//  PSContainerTransitionContext.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSContainerTransitionContext.h"
#import "PSFoudation.h"

@implementation PSContainerTransitionContext{
    NSDictionary *_privateViewControllers;
}
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController{
    PSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        _privateViewControllers = @{
                                    UITransitionContextFromViewControllerKey:fromViewController,
                                    UITransitionContextToViewControllerKey:toViewController,
                                    };
    }
    
    return self;
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return _privateViewControllers[key];
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc{
    return CGRectZero;
}
- (CGRect)finalFrameForViewController:(UIViewController *)vc{
    return CGRectZero;
}

- (BOOL)transitionWasCancelled{return NO;}

- (void)updateInteractiveTransition:(CGFloat)percentComplete{}
- (void)finishInteractiveTransition{}
- (void)cancelInteractiveTransition{}

- (void)completeTransition:(BOOL)didComplete{
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

@end
