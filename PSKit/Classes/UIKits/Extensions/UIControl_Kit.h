//
//  UIControl_Kit.h
//  PSKit
//
//  Created by PoiSon on 16/2/19.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PSEventHandler)(id sender, UIControlEvents events, UIEvent *event);

@interface UIControl (PSKit)

/** 移除事件处理器 */
- (void)ps_clearHandlersForEvents:(UIControlEvents)controlEvents;/**< Remove all handler for event.*/

/**
 *  与addTarget:action:forControlEvents:的效果一致
 */
- (void)ps_addHandler:(PSEventHandler)handler forControlEvents:(UIControlEvents)controlEvents;

- (void(^)(UIControlEvents event, id handler))ps_on;/**< 添加处理器，handler如果有参数，第一个为sender，第二个为UIEvent */
@end