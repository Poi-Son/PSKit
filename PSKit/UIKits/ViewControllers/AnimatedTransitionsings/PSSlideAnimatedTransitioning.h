//
//  SlideAnimation.h
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PSKit/PSConvenientMacro.h>

typedef NS_ENUM(NSUInteger, PSSlideTransitioningDirection){
    PSEnumOption(PSSlideTransitioningToLeft, 1, "向左侧滑动"),
    PSEnumOption(PSSlideTransitioningToRight, 2, "向右侧滑动"),
    PSEnumOption(PSSlideTransitioningToTop, 3, "向上滑动"),
    PSEnumOption(PSSlideTransitioningToBottom, 4, "向下滑动")
};

@interface PSSlideAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
+ (instancetype)animationWithSlideDirection:(PSSlideTransitioningDirection)direction;
+ (instancetype)animationWithSlideDirection:(PSSlideTransitioningDirection)direction isPop:(BOOL)isPop;
- (instancetype)initWithSlideDirection:(PSSlideTransitioningDirection)direction isPop:(BOOL)isPop;

@property (nonatomic, assign) NSTimeInterval duration;
@end
