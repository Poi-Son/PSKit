//
//  Handler.h
//  PSKit
//
//  Created by PoiSon on 15/9/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIAlertView (PSKit)
- (void)ps_showWithHandler:(void (^)(UIAlertView *alert, NSInteger buttonIndex))handler;
@end