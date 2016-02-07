//
//  PSContainerTransitionContext.h
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSContainerTransitionContext : NSObject<UIViewControllerContextTransitioning>
#pragma - 私有的UIViewControllerContextTransitioning声明
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController; /**< Designated initializer. */
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /**< A block of code we can set to execute after having received the completeTransition: message. */
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /**< Private setter for the animated property. */
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /**< Private setter for the interactive property. */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@end
