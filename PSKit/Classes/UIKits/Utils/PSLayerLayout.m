//
//  PSLayerLayout.m
//  PSKit
//
//  Created by PoiSon on 15/12/7.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSLayerLayout.h"
#import "PSAspect.h"
#import "PSFoudation.h"

typedef NS_ENUM(NSInteger, PSLayerLayoutMultiplyer) {
    PSKIT_ENUM_OPTION(PSLayerLayoutMultiplyerNegative, -1, "反向偏移"),
    PSKIT_ENUM_OPTION(PSLayerLayoutMultiplyerPositive, 1, "正向偏移")
};

@interface CALayer (PS_SUPER_SIZE)
@property (nonatomic, readonly) CGSize _superlayer_or_superview_size;/**< 父view或父layer的大小 */
@end

@interface PSResolveLayerX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(PSLayerLayoutMultiplyer)multiplyer;
@end

@interface PSResolveLayerY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(PSLayerLayoutMultiplyer)multiplyer;
@end

@interface PSResolveLayerCompleted ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
@property (nonatomic, strong) id owner;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(PSLayerLayoutMultiplyer)multiplyer;
@end

@implementation PSLayerLayout{
    CGPoint _location;
    CGSize _size;
    CALayer *_layer;
    CALayer *_relatedLayer;
}
#pragma mark - 初始化
- (instancetype)initWithLayer:(CALayer *)layer{
    if (self = [super init]) {
        _layer = layer ?: [[self class] ps_nil_layer_for_layout];
        _size = _layer.ps_size;
        _location = _layer.ps_location;
    }
    return self;
}

+ (instancetype)layoutForLayer:(CALayer *)layer{
    return [[self alloc] initWithLayer:layer];
}

+ (CALayer *)ps_nil_layer_for_layout{
    static CALayer *ps_nil_layer_instance;
    static CALayer *ps_nil_layer_superlayer_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ps_nil_layer_instance = [CALayer layer];
        ps_nil_layer_superlayer_instance = [CALayer layer];
        [ps_nil_layer_superlayer_instance addSublayer:ps_nil_layer_instance];
    });
    return ps_nil_layer_instance;
}
#pragma mark - 设置大小
- (PSLayerLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        _size = CGSizeMake(width, height);
        return self;
    };
}

- (PSLayerLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        _size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (PSResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ps_x - _size.width, _location.y);
        return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ps_x, _location.y);
        return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ps_x + layer.ps_width, _location.y);
        return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ps_x + layer.ps_width - _size.width, _location.y);
        return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ps_x + (layer.ps_width - _size.width) / 2, _location.y);
        return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerY *)alignParentLeft{
    _location = CGPointMake(0, _location.y);
    return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerY *)toParentLeft{
    _location = CGPointMake(-_size.width, _location.y);
    return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerY *)alignParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width - _size.width, _location.y);
    return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerY *)toParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width, _location.y);
    return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerY *)alignParentCenterWidth{
    _location = CGPointMake((_layer._superlayer_or_superview_size.width - _size.width)/ 2, _location.y);
    return [[PSResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (PSResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ps_y - _size.height);
        return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ps_y);
        return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ps_y + layer.ps_height);
        return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ps_y + layer.ps_height - _size.height);
        return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ps_y + (layer.ps_height - _size.height) / 2);
        return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerX *)alignParentTop{
    _location = CGPointMake(_location.x, 0);
    return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerX *)toParentTop{
    _location = CGPointMake(_location.x, - _size.height);
    return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerX *)alignParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height - _size.height);
    return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerX *)toParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height + _size.height);
    return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerX *)alignParentCenterHeight{
    _location = CGPointMake(_location.x, (_layer._superlayer_or_superview_size.height - _size.height) / 2);
    return [[PSResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (void)apply{
    _layer.ps_size = _size;
    _layer.ps_location = _location;
}
@end

@implementation PSResolveLayerX
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(PSLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveLayerX *)and{
    return self;
}

- (PSResolveLayerX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ps_x, self.location.y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)alignLeftL{
    self.location = CGPointMake(self.relatedLayer.ps_x, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ps_x + layer.ps_width - self.size.width, self.location.y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerCompleted *)alignRightL{
    self.location = CGPointMake(self.relatedLayer.ps_x + self.relatedLayer.ps_width - self.size.width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ps_x - self.size.width, self.location.y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerCompleted *)toLeftL{
    self.location = CGPointMake(self.relatedLayer.ps_x - self.size.width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ps_x + layer.ps_width, self.location.y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)toRightL{
    self.location = CGPointMake(self.relatedLayer.ps_x + self.relatedLayer.ps_width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ps_x + (layer.ps_width - self.size.width) / 2, self.location.y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)alignCenterWidthL{
    self.location = CGPointMake(self.relatedLayer.ps_x + (self.relatedLayer.ps_width - self.size.width) / 2, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)alignParentLeft{
    self.location = CGPointMake(0, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)toParentLeft{
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted *)alignParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width - self.size.width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted *)toParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width + self.size.width, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)alignParentCenterWidth{
    self.location = CGPointMake((self.layer._superlayer_or_superview_size.width - self.size.width) / 2, self.location.y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ps_size = self.size;
    self.layer.ps_location = self.location;
}
@end

@implementation PSResolveLayerY
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(PSLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveLayerY *)and{
    return self;
}

- (PSResolveLayerY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ps_y);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)alignTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ps_y);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ps_y + layer.ps_height - self.size.height);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerCompleted *)alignBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ps_y + self.relatedLayer.ps_height - self.size.height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ps_y - self.size.height);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
    };
}

- (PSResolveLayerCompleted *)toTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ps_y - self.size.height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ps_y + layer.ps_height);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)toBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ps_y + self.relatedLayer.ps_height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ps_y + (layer.ps_height - self.size.height) / 2);
        return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
    };
}

- (PSResolveLayerCompleted *)alignCenterHeightL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ps_y + (self.relatedLayer.ps_height - self.size.height) / 2);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)alignParentTop{
    self.location = CGPointMake(self.location.x, 0);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)toParentTop{
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted *)alignParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height - self.size.height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerNegative];
}

- (PSResolveLayerCompleted *)toParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height + self.size.height);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (PSResolveLayerCompleted *)alignParentCenterHeight{
    self.location = CGPointMake(self.location.x, (self.layer._superlayer_or_superview_size.height - self.size.height) / 2);
    return [[PSResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:PSLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ps_size = self.size;
    self.layer.ps_location = self.location;
}
@end
@implementation PSResolveLayerCompleted
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(PSLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveLayerCompleted * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[PSResolveLayerY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.layer.ps_size = self.size;
    self.layer.ps_location = self.location;
}

@end


@implementation CALayer (Layout)

- (CGFloat)ps_x{
    return self.position.x - self.anchorPoint.x * self.ps_width;
}

- (void)setPs_x:(CGFloat)ps_x{
    self.position = CGPointMake(ps_x + self.anchorPoint.x * self.ps_width, self.position.y);
}

- (CGFloat)ps_y{
    return self.position.y - self.anchorPoint.y * self.ps_height;
}

- (void)setPs_y:(CGFloat)ps_y{
    self.position = CGPointMake(self.position.x, ps_y + self.anchorPoint.y * self.ps_height);
}

- (CGFloat)ps_width{
    return self.bounds.size.width;
}

- (void)setPs_width:(CGFloat)ps_width{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(ps_width, self.ps_height)};
}

- (CGFloat)ps_height{
    return self.bounds.size.height;
}

- (void)setPs_height:(CGFloat)ps_height{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.ps_width, ps_height)};
}

- (CGSize)ps_size{
    return self.bounds.size;
}

- (void)setPs_size:(CGSize)ps_size{
    self.bounds = (CGRect){CGPointZero, ps_size};
}

- (CGPoint)ps_location{
    return CGPointMake(self.ps_x, self.ps_y);
}

- (void)setPs_location:(CGPoint)ps_location{
    self.position = CGPointMake(ps_location.x + self.anchorPoint.x * self.ps_width, ps_location.y + self.anchorPoint.y * self.ps_height);
}
@end

@implementation CALayer (PS_SUPER_SIZE)
- (CGSize)_superlayer_or_superview_size{
    PSAssert(self.superlayer, @"can't find superlayer in layer:%@", self);
    return self.superlayer.ps_size;
}
@end
