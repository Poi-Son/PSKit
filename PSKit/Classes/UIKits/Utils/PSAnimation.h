//
//  PSAnimationAction.h
//  PSKit
//
//  Created by PoiSon on 15/11/26.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  简单封装[UIView animation...]系列动画
 */
@interface PSAnimation : NSObject
+ (PSAnimation *(^)(void (^action)()))before; /**< 动画准备动作(创建一个新的动作) */
+ (PSAnimation *(^)(NSTimeInterval duration, void (^action)()))begin; /**< 开始动画动作(创建一个新的动作) */

@property (nonatomic, readonly) PSAnimation *(^before)(void (^action)()); /**< 添加动画准备动作 */
@property (nonatomic, readonly) PSAnimation *(^begin)(NSTimeInterval duration, void (^action)()); /**< 添加开始动作 */
@property (nonatomic, readonly) PSAnimation *(^delay)(NSTimeInterval delay); /**< 添加等待时间 */
@property (nonatomic, readonly) PSAnimation *(^then)(NSTimeInterval duration, void (^action)()); /**< 添加继续动作 */
@property (nonatomic, readonly) PSAnimation *(^final)(void (^action)()); /**< 动画完成后执行的动作 */

- (void)action;/**< 开始执行动画 */
@end
NS_ASSUME_NONNULL_END