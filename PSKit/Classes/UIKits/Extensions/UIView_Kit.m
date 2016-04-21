//
//  UIView+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "UIView_Kit.h"
#import "NSObject_Kit.h"
#import "PSFoudation.h"

@implementation UIView (Kit)
@dynamic ps_tag;
- (void)ps_clearSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
PSAssociatedKeyAndNotes(PS_VIEW_TAG_OBJECT, "Store the tag value");
- (void)setPs_tag:(id)ps_tag useStorePolicy:(PSStorePolicy)plolicy{
    [self ps_setAssociatedObject:ps_tag forKey:PS_VIEW_TAG_OBJECT usingProlicy:plolicy];
}

- (id)ps_tag{
    return [self ps_associatedObjectForKey:PS_VIEW_TAG_OBJECT];
}

- (void)setPs_tag:(id)ps_tag{
    returnIf(ps_tag == nil);
    [self ps_setAssociatedObject:ps_tag forKey:PS_VIEW_TAG_OBJECT usingProlicy:PSStoreUsingRetainNonatomic];
}

- (UIViewController *)ps_viewController{
    UIResponder *next;
    while ((next = [self nextResponder])) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
    }
    return nil;
}

- (UIImage *)ps_snapshot{
    CGFloat oldAlpha = self.alpha;
    self.alpha = 1;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
    return resultingImage;
}

- (void)ps_bringSelfToFront{
    [self.superview bringSubviewToFront:self];
}

- (NSArray<UIView *> *)ps_findSubviewsWithType:(Class)viewType{
    NSMutableArray<UIView *> *views = [NSMutableArray new];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewType]) {
            [views addObject:view];
        }else{
            [views addObjectsFromArray:[view ps_findSubviewsWithType:viewType]];
        }
    }
    return views;
}

- (UIView *)ps_findFirstSubviewWithType:(Class)viewType{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewType]) {
            return view;
        }else{
            UIView *subView = [view ps_findFirstSubviewWithType:viewType];
            returnValIf(subView, subView);
        }
    }
    return nil;
}

+ (instancetype)ps_instanceWithNibName:(NSString *)nibNameOrNil bundel:(NSBundle *)nibBundleOrNil{
    if (!nibBundleOrNil) {
        nibBundleOrNil = [NSBundle mainBundle];
    }
    if (!nibNameOrNil.length) {
        nibNameOrNil = NSStringFromClass(self);
    }
    NSArray *nibView = [nibBundleOrNil loadNibNamed:nibNameOrNil owner:nil options:nil];
    if (nibView.count) {
        return nibView[0];
    }else{
        PSAssertFail(@"Could not load NIB in bundle: '%@' with name '%@'", nibBundleOrNil, nibNameOrNil);
        return nil;
    }
}
@end
