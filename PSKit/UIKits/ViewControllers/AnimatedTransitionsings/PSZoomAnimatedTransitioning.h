//
//  MDZoomAnimation.h
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSZoomAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
#pragma - Push动画
+ (instancetype)animationFromFrame:(CGRect)frame;
- (instancetype)initWithFromFrame:(CGRect)frame;

#pragma - Push动画
+ (instancetype)animationToFrame:(CGRect)frame;
- (instancetype)initWithToFrame:(CGRect)frame;

@property (nonatomic, assign) NSTimeInterval duration;
@end
