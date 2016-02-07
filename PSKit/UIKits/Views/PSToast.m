 //
//  PSToast.m
//  PSKit
//
//  Created by PoiSon on 15/11/18.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSToast.h"
#import "PSLayout.h"
#import "PSFoudation.h"
#import "PSAnimation.h"

NSUInteger const PSToastLengthShort = 2;
NSUInteger const PSToastLengthLong = 4;

#define kToastMaxWidth 200

@interface PSToast ()
@property (nonatomic, copy) NSString *identifier;
@end

@interface PSToastViewController : UIViewController
- (instancetype)initWithToast:(PSToast *)toast;
- (void)dismissCompleted:(void (^)())completed;
@end

@implementation PSToast{
    NSString *_toastIdentifier;
    UIView *_toastView;
}

+ (instancetype)toastWithText:(NSString *)text duration:(NSUInteger)duration{
    PSToast *toast = [self new];
    toast.text = text;
    toast.duration = duration;
    toast.position = 100.0f;
    return toast;
}

+ (instancetype)toastWithView:(UIView *)view duration:(NSUInteger)duration{
    PSToast *toast = [self new];
    toast.view = view;
    toast.text = @"";
    toast.duration = duration;
    toast.position = 100.0f;
    return toast;
}

+ (instancetype)toastWithText:(NSString *)text andView:(UIView *)view duration:(NSUInteger)duration{
    PSToast *toast = [self new];
    toast.text = text;
    toast.view = view;
    toast.duration = duration;
    toast.position = 100.0f;
    return toast;
}

- (void)show{
    static NSMutableSet<UIWindow *> *container;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container = [NSMutableSet new];
    });
    
    [self ps_performBlockSync:^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIWindow *window = [[UIWindow alloc] initWithFrame:keyWindow.bounds];
        PSToastViewController *viewController = [[PSToastViewController alloc] initWithToast:self];
        window.rootViewController = viewController;
        window.userInteractionEnabled = NO;
        
        [container addObject:window];
        [window makeKeyAndVisible];
        
        [window ps_performBlockSync:^{
            [viewController dismissCompleted:^{
                [container removeObject:window];
            }];
        } afterDelay:self.duration];
    }];
}

@end

@implementation PSToastViewController{
    PSToast *_toast;
    UIView *_messageView;
}
- (instancetype)initWithToast:(PSToast *)toast{
    if (self = [super init]) {
        _toast = toast;
    }
    return self;
}

- (void)viewDidLoad{
    self.view.userInteractionEnabled = NO;
    
    doIf(_toast.text.length < 1 && !_toast.view, _toast.text = @" ");
    
    UIView *customView = _toast.view;
    UILabel *messageLabel = _toast.text.length < 1 ? nil : ({
        UILabel *label = [UILabel new];
        label.text = _toast.text;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        [label sizeToFit];
        label;
    });
    
    _messageView = ({
        CGFloat maxWidth = MAX(messageLabel.ps_width, customView.ps_width);
        CGFloat height = messageLabel.ps_height + customView.ps_height;
        doIf(customView && messageLabel, height += 5);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth + 30, height + 20)];
        view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        view.layer.cornerRadius = 5.0f;
        view.layer.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
        view.layer.shadowOpacity = 1;
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowRadius = 5;
        view.alpha = 0;
        view;
    });
    doIf(messageLabel, [_messageView addSubview:messageLabel]);
    doIf(customView, [_messageView addSubview:customView]);
    
    if (_toast.view) {
        [_messageView addSubview:_toast.view];
        [PSLayoutV(_toast.view).alignParentCenterWidth.and.alignParentTop.distance(10) apply];
        [PSLayoutV(messageLabel).alignParentCenterWidth.and.toBottom(_toast.view).distance(5) apply];
    }else{
        [PSLayoutV(messageLabel).alignParentCenterWidth.and.alignParentCenterHeight apply];
    }
    
    [self.view addSubview:_messageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [PSAnimation.before(^{
        _messageView.alpha = 0;
    }).begin(0.5, ^{
        _messageView.alpha = 1;
    }) action];
}

- (void)viewDidLayoutSubviews{
    [PSLayoutV(_messageView).alignParentBottom.distance(_toast.position).alignParentCenterWidth apply];
}

- (void)dismissCompleted:(void (^)())completed{
    [PSAnimation.new.begin(0.8, ^{
        _messageView.alpha = 0;
    }).final(^{
        doIf(completed, completed());
    }) action];
}

@end
