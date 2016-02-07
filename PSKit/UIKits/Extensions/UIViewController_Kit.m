//
//  Kit.m
//  PSKit
//
//  Created by PoiSon on 16/1/7.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import "UIViewController_Kit.h"
#import "PSFoudation.h"

@implementation UIViewController (Kit)
PSAssociatedKey(PS_ON_CONTROLLER_RESULT_BLOCK);
- (void (^)(UIViewController *, NSUInteger, NSDictionary *))ps_onControllerResult{
    return [self ps_associatedObjectForKey:PS_ON_CONTROLLER_RESULT_BLOCK storeProlicy:PSStoreUsingCopyNonatomic setDefault:^id _Nonnull{
        return ^(UIViewController *viewController, NSUInteger code, NSDictionary *data){};//设置一个空的block，这样就不需要总是先判断了
    }];
}

- (void)setPs_onControllerResult:(void (^)(UIViewController *, NSUInteger, NSDictionary *))ps_onControllerResult{
    [self ps_setAssociatedObject:ps_onControllerResult forKey:PS_ON_CONTROLLER_RESULT_BLOCK usingProlicy:PSStoreUsingCopyNonatomic];
}
@end
