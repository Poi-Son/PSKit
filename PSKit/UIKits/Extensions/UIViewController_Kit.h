//
//  Kit.h
//  PSKit
//
//  Created by PoiSon on 16/1/7.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Kit)
/** 类似于安卓的onActivityResult，自身调用即可。不需要判空 */
@property (nonatomic, copy) void (^ps_onControllerResult)(UIViewController *controller, NSUInteger resultCode, NSDictionary *data);
- (void)setPs_onControllerResult:(void (^)(UIViewController *controller, NSUInteger resultCode, NSDictionary *data))ps_onControllerResult;
@end
