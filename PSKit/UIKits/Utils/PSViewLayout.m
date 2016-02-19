//
//  MDLayout.m
//  LayoutTest
//
//  Created by PoiSon on 15/5/14.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSViewLayout.h"
#import "PSFoudation.h"

typedef NS_ENUM(NSInteger, PSViewLayoutMultiplyer) {
    PSKIT_ENUM_OPTION(PSViewLayoutMultiplyerNegative, -1, "反向偏移"),
    PSKIT_ENUM_OPTION(PSViewLayoutMultiplyerPositive, 1, "正向偏移")
};

@interface PSResolveViewX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(PSViewLayoutMultiplyer)multiplyer;
@end

@interface PSResolveViewY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(PSViewLayoutMultiplyer)multiplyer;
@end

@interface PSResolveViewComplete ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) PSViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
@property (nonatomic, strong) id owner;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(PSViewLayoutMultiplyer)multiplyer;
@end

@implementation PSViewLayout{
    CGPoint _location;
    CGSize _size;
    UIView *_view;
    UIView *_relatedView;
}
#pragma mark - 初始化
+ (instancetype)layoutForView:(UIView *)view{
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        _view = view ?: [[self class] ps_nil_view_for_layout];
        _size = _view.ps_size;
        _location = _view.ps_location;
    }
    return self;
}

+ (UIView *)ps_nil_view_for_layout{
    static UIView *ps_nil_view_instance;
    static UIView *ps_nil_view_superview_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ps_nil_view_instance = [UIView new];
        ps_nil_view_superview_instance = [UIView new];
        [ps_nil_view_superview_instance addSubview:ps_nil_view_instance];
    });
    
    return ps_nil_view_instance;
}

- (instancetype)init{
    return [self initWithView:[PSViewLayout ps_nil_view_for_layout]];
}
#pragma mark - 设置大小
- (PSViewLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        _size = CGSizeMake(width, height);
        return self;
    };
}

- (PSViewLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        _size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (PSResolveViewY * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(view.ps_x - _size.width, _location.y);
        return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(view.ps_x, _location.y);
        return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewY * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(view.ps_x + view.ps_width, _location.y);
        return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(view.ps_x + view.ps_width - _size.width, _location.y);
        return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(view.ps_x + (view.ps_width - _size.width) / 2, _location.y);
        return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewY *)alignParentLeft{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(0, _location.y);
    return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewY *)toParentLeft{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(-_size.width, _location.y);
    return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewY *)alignParentRight{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ps_width - _size.width, _location.y);
    return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewY *)toParentRight{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ps_width, _location.y);
    return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewY *)alignParentCenterWidth{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake((_view.superview.ps_width - _size.width) / 2, _location.y);
    return [[PSResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (PSResolveViewX * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(_location.x, view.ps_y - _size.height);
        return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(_location.x, view.ps_y);
        return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewX * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(_location.x, view.ps_y + view.ps_height);
        return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(_location.x, view.ps_y + view.ps_height - _size.height);
        return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:_view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        _location = CGPointMake(_location.x, view.ps_y + (view.ps_height - _size.height) / 2);
        return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewX *)alignParentTop{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, 0);
    return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewX *)toParentTop{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, - _size.height);
    return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewX *)alignParentBottom{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ps_height - _size.height);
    return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewX *)toParentBottom{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ps_height + _size.height);
    return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewX *)alignParentCenterHeight{
    PSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, (_view.superview.ps_height - _size.height) / 2);
    return [[PSResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:PSViewLayoutMultiplyerPositive];
}

- (void)apply{
    _view.frame = (CGRect){_location, _size};
}

@end

@implementation PSResolveViewX
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(PSViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveViewX *)and{
    return self;
}

- (PSResolveViewX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(view.ps_x, self.location.y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)alignLeftV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ps_x, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(view.ps_x + view.ps_width - self.size.width, self.location.y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewComplete *)alignRightV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ps_x + self.relatedView.ps_width - self.size.width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(view.ps_x - self.size.width, self.location.y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewComplete *)toLeftV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ps_x - self.size.width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(view.ps_x + view.ps_width, self.location.y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)toRightV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ps_x + self.relatedView.ps_width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(view.ps_x + (view.ps_width - self.size.width) / 2, self.location.y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)alignCenterWidthV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ps_x + (self.relatedView.ps_width - self.size.width) / 2, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)alignParentLeft{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(0, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)toParentLeft{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete *)alignParentRight{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ps_width - self.size.width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete *)toParentRight{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ps_width + self.size.width, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)alignParentCenterWidth{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake((self.view.superview.ps_width - self.size.width) / 2, self.location.y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation PSResolveViewY
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(PSViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveViewY *)and{
    return self;
}

- (PSResolveViewY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(self.location.x, view.ps_y);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)alignTopV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ps_y);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(self.location.x, view.ps_y + view.ps_height - self.size.height);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewComplete *)alignBottomV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ps_y + self.relatedView.ps_height - self.size.height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(self.location.x, view.ps_y - self.size.height);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
    };
}

- (PSResolveViewComplete *)toTopV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ps_y - self.size.height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(self.location.x, view.ps_y + view.ps_height);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)toBottomV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ps_y + self.relatedView.ps_height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        doIf([view isEqual:self.view.superview], PSLog(@"[WARNING]: relatedView is superview, check your expression"));
        self.location = CGPointMake(self.location.x, view.ps_y + (view.ps_height - self.size.height) / 2);
        return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
    };
}

- (PSResolveViewComplete *)alignCenterHeightV{
    PSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ps_y + (self.relatedView.ps_height - self.size.height) / 2);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)alignParentTop{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, 0);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)toParentTop{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete *)alignParentBottom{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ps_height - self.size.height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerNegative];
}

- (PSResolveViewComplete *)toParentBottom{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ps_height + self.size.height);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (PSResolveViewComplete *)alignParentCenterHeight{
    PSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, (self.view.superview.ps_height - self.size.height) / 2);
    return [[PSResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:PSViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation PSResolveViewComplete
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(NSObject *)owner multiplyer:(PSViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (PSResolveViewComplete * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[PSResolveViewY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}

@end

@implementation UIView(Layout)

- (CGFloat)ps_x{
    return self.frame.origin.x;
}

- (void)setPs_x:(CGFloat)ps_x{
    self.frame = (CGRect){CGPointMake(ps_x, self.ps_y), self.ps_size};
}

- (CGFloat)ps_y{
    return self.frame.origin.y;
}

- (void)setPs_y:(CGFloat)ps_y{
    self.frame = (CGRect){CGPointMake(self.ps_x, ps_y), self.ps_size};
}

- (CGFloat)ps_width{
    return self.frame.size.width;
}

- (void)setPs_width:(CGFloat)ps_width{
    self.frame = (CGRect){self.ps_location, CGSizeMake(ps_width, self.ps_height)};
}

- (CGFloat)ps_height{
    return self.frame.size.height;
}

- (void)setPs_height:(CGFloat)ps_height{
    self.frame = (CGRect){self.ps_location, CGSizeMake(self.ps_width, ps_height)};
}

- (CGSize)ps_size{
    return self.frame.size;
}

- (void)setPs_size:(CGSize)ps_size{
    self.frame = (CGRect){self.ps_location, ps_size};
}

- (CGPoint)ps_location{
    return self.frame.origin;
}

- (void)setPs_location:(CGPoint)ps_location{
    self.frame = (CGRect){ps_location, self.ps_size};
}
@end
