//
//  MDFadeAnimation.h
//  SSEnterprise
//
//  Created by PoiSon on 15/4/27.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSFadeAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)init;/**< 默认使用0.4秒淡出 */
- (instancetype)initWithDuration:(NSTimeInterval)duration;/**< 自定义淡出时间 */
@end
