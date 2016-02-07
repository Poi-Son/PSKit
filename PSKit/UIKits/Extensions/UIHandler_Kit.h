//
//  Handler.h
//  PSKit
//
//  Created by PoiSon on 15/9/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/****************************************************************************
 * UIAlertView Handler
 ****************************************************************************/
@interface UIAlertView (Handler)
- (void)ps_showWithHandler:(void (^)(UIAlertView *alert, NSInteger buttonIndex))handler;
@end


/****************************************************************************
 * UIControl Event Handler
 ****************************************************************************/
typedef void (^PSEventHandler)(id sender, UIControlEvents events, UIEvent *event);

@interface UIControl (PSKit)

/** 移除事件处理器 */
- (void)ps_clearHandlersForEvents:(UIControlEvents)controlEvents;/**< Remove all handler for event.*/

/**
 *  与addTarget:action:forControlEvents:的效果一致
 */
- (void)ps_addHandler:(PSEventHandler)handler forControlEvents:(UIControlEvents)controlEvents;
@end