//
//  PSContainerViewController.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSKit/PSAnimatedTransitionsings.h>

NS_ASSUME_NONNULL_BEGIN

@class PSContainerViewController;

@interface UIViewController(PSContainer)
@property (nonatomic, retain, readonly) PSContainerViewController *ps_container;
@end

@interface PSContainerViewController : UIViewController
/** 容器视图.默认返回self.view */
- (UIView *)containerView;
/** 当前ViewController. */
- (UIViewController *)currentViewController;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;

#pragma - 实现类似NavigationViewController的功能
/**
 *  设置根ViewController
 *
 *  @param viewController 目标ViewController
 *  @param animation      动画
 */
- (void)setRootViewController:(UIViewController *)viewController animation:(nullable id<UIViewControllerAnimatedTransitioning> )animation;

/**
 *  设置ViewController
 *
 *  @param viewControllers 目标ViewControllers
 *  @param animation       动画
 */
- (void)setViewControllers:(NSArray *)viewControllers animation:(nullable id<UIViewControllerAnimatedTransitioning>)animation;

/**
 *  使用动画效果切换Controller
 */
- (void)pushViewController:(UIViewController *)viewController animation:(nullable id<UIViewControllerAnimatedTransitioning>)animation;

/**
 *  弹出顶层的ViewController
 *
 *  @param animation 动画
 *
 *  @return 被弹出的ViewController
 */
- (UIViewController *)popViewControllerWithAnimation:(id<UIViewControllerAnimatedTransitioning>)animation;
/**
 *  弹出顶层的ViewControllers, 直到遇到指写的ViewController
 *
 *  @param viewController 指定的ViewController
 *  @param animation      动画
 *
 *  @return 被弹出来的所有ViewControllers
 */
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController withAnimation:(id<UIViewControllerAnimatedTransitioning>)animation;
/**
 *  弹出顶层所有的ViewController, 直到只剩下一个
 *
 *  @param animation 动画
 *
 *  @return 被弹出来的所有ViewControllers
 */
- (NSArray<UIViewController *> *)popToRootViewControllerWithAnimation:(id<UIViewControllerAnimatedTransitioning>)animation;
@end
NS_ASSUME_NONNULL_END
