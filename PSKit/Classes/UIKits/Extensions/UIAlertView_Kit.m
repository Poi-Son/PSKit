//
//  UIAlertView+Handler.m
//  PSKit
//
//  Created by PoiSon on 15/9/17.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "UIAlertView_Kit.h"
#import "PSFoudation.h"

const char PS_HANDLER_KEY;

@interface UIAlertView() <UIAlertViewDelegate>

@end

@implementation UIAlertView (PSKit)
- (void)ps_showWithHandler:(void (^)(UIAlertView *, NSInteger))handler{
    if (handler) {
        self.delegate = self;
        //保存handler
        [self ps_setAssociatedObject:handler forKey:&PS_HANDLER_KEY usingProlicy:PSStoreUsingCopyNonatomic];
        [self show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^handler)(UIAlertView *, NSInteger) = [self ps_associatedObjectForKey:&PS_HANDLER_KEY];
    if (handler) {
        handler(self, buttonIndex);
    }
}

@end
