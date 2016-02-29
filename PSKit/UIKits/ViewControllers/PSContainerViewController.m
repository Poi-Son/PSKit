//
//  PSContainerViewController.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSContainerViewController.h"
#import "PSContainerTransitionContext.h"
#import "PSFoudation.h"

#pragma - UIViewController container

@implementation UIViewController(PSContainer)
PSAssociatedKeyAndNotes(PS_CONTAINER_KEY, "Store the weak reference of the container controller");
- (PSContainerViewController *)ps_container{
    return [self ps_associatedObjectForKey:PS_CONTAINER_KEY];
}
- (void)setPs_container:(PSContainerViewController *)ps_container{
    [self ps_setAssociatedObject:ps_container forKey:PS_CONTAINER_KEY usingProlicy:PSStoreUsingAssign];
}
@end

@interface PSContainerViewController()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSMutableArray *vcStack;
@end

@implementation PSContainerViewController{
    UIViewController *_currentVC;
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _vcStack = [NSMutableArray arrayWithObjects:viewController, nil];
        
        viewController.ps_container = self;
        
        [viewController willMoveToParentViewController:self];
        [self addChildViewController:viewController];
        
        viewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        _currentVC = viewController;
    }
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers{
    if (self = [super init]) {
        _vcStack = [NSMutableArray arrayWithArray:viewControllers];
        for (UIViewController *vc in viewControllers) {
            vc.ps_container = self;
        }
        
        UIViewController *viewController = [_vcStack lastObject];
        [viewController willMoveToParentViewController:self];
        [self addChildViewController:viewController];
        
        viewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        _currentVC = viewController;
    }
    return self;
}
- (UIView *)containerView{
    return self.view;
}

- (UIViewController *)currentViewController{
    return _currentVC;
}

- (void)setViewControllers:(NSArray *)viewControllers animation:(id<UIViewControllerAnimatedTransitioning>)animation{
    PSAssert(viewControllers.count, @"正在尝试设置空viewControllers");
    
    UIViewController *viewController = viewControllers.lastObject;
    UIViewController *fromViewController = _vcStack.count ? [_vcStack lastObject] : nil;
    _currentVC = viewController;
    
    if (viewController == fromViewController || !self.isViewLoaded) {
        [_vcStack removeAllObjects];
        doIf(fromViewController, [_vcStack addObject:fromViewController]);
        return;
    }
    
    if ([viewController respondsToSelector:@selector(setPs_container:)]) {
        viewController.ps_container = self;
    }
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    [fromViewController willMoveToParentViewController:nil];
    
    viewController.view.frame = self.containerView.bounds;
    
    if (fromViewController == nil || animation == nil) {
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
        
        [self.vcStack removeAllObjects];
        [self.vcStack addObject:viewController];
        return;
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:viewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [selfObj.vcStack removeAllObjects];
                                  [selfObj.vcStack addObject:viewController];
                                  [viewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
}

- (void)setRootViewController:(UIViewController *)viewController animation:(id<UIViewControllerAnimatedTransitioning>)animation{
    PSAssert(viewController, @"正在尝试设置空viewController");
    
    _currentVC = viewController;
    UIViewController *fromViewController = _vcStack.count ? [_vcStack lastObject] : nil;
    if (viewController == fromViewController || !self.isViewLoaded) {
        [_vcStack removeAllObjects];
        doIf(fromViewController, [_vcStack addObject:fromViewController]);
        return;
    }
    
    if ([viewController respondsToSelector:@selector(setPs_container:)]) {
        viewController.ps_container = self;
    }
    
    
    [self.vcStack removeAllObjects];
    [self.vcStack addObject:viewController];
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    [fromViewController willMoveToParentViewController:nil];
    
    viewController.view.frame = self.containerView.bounds;
    
    if (fromViewController == nil || animation == nil) {
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
        
        
        return;
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:viewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [viewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
}

- (void)pushViewController:(UIViewController *)viewController animation:(id<UIViewControllerAnimatedTransitioning>)animation{
    PSAssert(viewController, @"正在尝试设置空viewController");
    
    _currentVC = viewController;
    
    UIViewController *fromViewController = _vcStack.count ? [_vcStack lastObject] : nil;
    if (viewController == fromViewController || !self.isViewLoaded) {
        return;
    }
    
    if ([viewController respondsToSelector:@selector(setPs_container:)]) {
        viewController.ps_container = self;
    }
    
    [viewController willMoveToParentViewController:self];
    [self.vcStack addObject:viewController];
    [self addChildViewController:viewController];
    
    [fromViewController willMoveToParentViewController:nil];
    
    viewController.view.frame = self.containerView.bounds;
    
    if (fromViewController == nil || animation == nil) {
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
        return;
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:viewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [viewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
}

- (UIViewController *)popViewControllerWithAnimation:(id<UIViewControllerAnimatedTransitioning>)animation{
    if (self.vcStack.count < 2) {
        return nil;
    }
    
    UIViewController *fromViewController = [self.vcStack lastObject];
    [self.vcStack removeLastObject];
    
    UIViewController *toViewController = [self.vcStack lastObject];
    _currentVC = toViewController;
    
    [fromViewController willMoveToParentViewController:nil];
    
    [toViewController willMoveToParentViewController:self];
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.containerView.bounds;
    
    
    if (animation == nil) {
        [self.containerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:toViewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [toViewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
    
    return fromViewController;
}

- (NSArray *)popToRootViewControllerWithAnimation:(id<UIViewControllerAnimatedTransitioning>)animation{
    if (self.vcStack.count < 2) {
        return nil;
    }
    
    UIViewController *fromViewController = [self.vcStack lastObject];
    NSMutableArray *popedVCs = [self.vcStack mutableCopy];
    [popedVCs removeObjectAtIndex:0];
    [self.vcStack removeObjectsInArray:popedVCs];
    
    UIViewController *toViewController = [self.vcStack lastObject];
    
    _currentVC = toViewController;
    
    [fromViewController willMoveToParentViewController:nil];
    
    [toViewController willMoveToParentViewController:self];
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.containerView.bounds;
    
    if (animation == nil) {
        [self.containerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:toViewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [toViewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
    
    return popedVCs;
}

- (NSArray *)popToViewController:(UIViewController *)viewController withAnimation:(id<UIViewControllerAnimatedTransitioning>)animation{
    PSAssert([_vcStack containsObject:viewController], @"ViewController栈中没有该viewController");
    
    UIViewController *fromViewController = [self.vcStack lastObject];
    NSMutableArray *popedVCs = [self.vcStack mutableCopy];
    [popedVCs removeObjectAtIndex:0];
    [self.vcStack removeObjectsInArray:popedVCs];
    
    NSUInteger index = [self.vcStack indexOfObject:viewController];
    [self.vcStack removeObjectsInRange:NSMakeRange(index, self.vcStack.count - index)];
    
    UIViewController *toViewController = viewController;
    
    _currentVC = toViewController;
    
    [fromViewController willMoveToParentViewController:nil];
    
    [toViewController willMoveToParentViewController:self];
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.containerView.bounds;
    
    if (animation == nil) {
        [self.containerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
    }else{
        __block PSContainerViewController *selfObj = self;
        [self switchFormViewController:fromViewController
                      toViewController:toViewController
                             animation:animation
                              complete:^(BOOL didComplete) {
                                  [toViewController didMoveToParentViewController:selfObj];
                                  
                                  [fromViewController.view removeFromSuperview];
                                  [fromViewController removeFromParentViewController];
                                  [fromViewController didMoveToParentViewController:nil];
                              }];
    }
    
    return popedVCs;
}

- (void)switchFormViewController:(UIViewController *)fromViewController
                toViewController:(UIViewController *)toViewController
                       animation:(id<UIViewControllerAnimatedTransitioning>)animation
                        complete:(void(^)(BOOL didComplete))complete{
    
    PSContainerTransitionContext *context = [[PSContainerTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController];
    context.animated = YES;
    context.interactive = NO;
    context.completionBlock = ^(BOOL didComplete){
        complete(didComplete);
    };
    [animation animateTransition:context];
}
@end




