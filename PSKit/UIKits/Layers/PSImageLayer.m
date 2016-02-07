//
//  PSImageLayer.m
//  PSKit
//
//  Created by PoiSon on 15/12/9.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSImageLayer.h"
#import "PSFoudation.h"
#import "UIImage_Kit.h"

#define PS_IMAGE_CODE_KEY @"PS_IMAGE_CODE_KEY"
#define PS_HIGHLIGHTEDIMAGE_CODE_KEY @"PS_HIGHLIGHTEDIMAGE_CODE_KEY"
#define PS_HIGHLIGHTED_CODE_KEY @"PS_HIGHLIGHTED_CODE_KEY"
#define PS_TINTCOLOR_CODE_KEY @"PS_TINTCOLOR_CODE_KEY"

@implementation PSImageLayer{
    BOOL _is_displayed;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:PS_IMAGE_CODE_KEY];
    [aCoder encodeObject:self.highlightedImage forKey:PS_HIGHLIGHTEDIMAGE_CODE_KEY];
    [aCoder encodeBool:self.highlighted forKey:PS_HIGHLIGHTED_CODE_KEY];
    [aCoder encodeObject:self.tintColor forKey:PS_TINTCOLOR_CODE_KEY];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.image = [aDecoder decodeObjectForKey:PS_IMAGE_CODE_KEY];
        self.highlightedImage = [aDecoder decodeObjectForKey:PS_HIGHLIGHTEDIMAGE_CODE_KEY];
        self.highlighted = [aDecoder decodeBoolForKey:PS_HIGHLIGHTED_CODE_KEY];
        self.tintColor = [aDecoder decodeObjectForKey:PS_TINTCOLOR_CODE_KEY];
        [self setNeedsDisplay];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image{
    return [self initWithImage:image highlightedImage:nil];
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    if (self = [super init]) {
        self.image = image;
        self.highlightedImage = highlightedImage;
        self.bounds = (CGRect){CGPointZero, image.size};
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    doIf(_is_displayed, [self _ps_set_image_animated:NO]);
}

- (void)setHighlightedImage:(UIImage *)highlightedImage{
    _highlightedImage = highlightedImage;
    doIf(_is_displayed, [self _ps_set_image_animated:NO]);
}

- (void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    doIf(_is_displayed, [self _ps_set_image_animated:NO]);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _highlighted = highlighted;
    [self _ps_set_image_animated:animated];
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    doIf(_is_displayed, [self _ps_set_image_animated:NO]);
}

- (void)_ps_set_image_animated:(BOOL)isAnimated{
    [CATransaction begin];
    [CATransaction setDisableActions:!isAnimated];
    UIImage *targetImage = nil;
    if (self.isHighlighted && self.highlightedImage) {
        targetImage = self.highlightedImage;
    }else if (self.image){
        targetImage = self.image;
    }else{
        targetImage = nil;
    }
    if (_tintColor) {
        targetImage = [UIImage ps_imageWithImage:targetImage tintColor:_tintColor];
    }
    self.contents = (id)targetImage.CGImage;
    [CATransaction commit];
}

- (void)display{
    [super display];
    _is_displayed = YES;
    [self _ps_set_image_animated:NO];
}

@end
