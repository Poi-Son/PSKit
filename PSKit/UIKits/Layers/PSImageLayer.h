//
//  PSImageLayer.h
//  PSKit
//
//  Created by PoiSon on 15/12/9.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
/**
 *  图片图层
 */
@interface PSImageLayer : CALayer

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

@property (nullable, nonatomic, strong) UIImage *image;
@property (nullable, nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@property (null_resettable, nonatomic, strong) UIColor *tintColor;
@end
NS_ASSUME_NONNULL_END