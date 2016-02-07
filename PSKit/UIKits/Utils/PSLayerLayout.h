//
//  PSLayerLayout.h
//  PSKit
//
//  Created by PoiSon on 15/12/7.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSResolveLayerX;
@class PSResolveLayerY;
@class PSResolveLayerCompleted;

NS_ASSUME_NONNULL_BEGIN

#define PSLayoutL(layer) [PSLayerLayout layoutForLayer:layer]
/**
 *  Layer布局
 *  注: Parent系列布局函数, 在superlayer为空时, 则与layer所在的UIView中的位置进行布局
 */
@interface PSLayerLayout : NSObject
+ (instancetype)layoutForLayer:(CALayer *)layer;
- (instancetype)initWithLayer:(CALayer *)layer NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) PSLayerLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) PSLayerLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) PSResolveLayerY *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) PSResolveLayerY *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) PSResolveLayerY *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) PSResolveLayerY *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) PSResolveLayerY *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */

@property (nonatomic, readonly) PSResolveLayerY *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerY *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerY *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerY *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerY *alignParentCenterWidth;/**< 父Layer横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) PSResolveLayerX *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) PSResolveLayerX *(^toTop)(CALayer *relatedLayer);/**< 在上侧 */
@property (nonatomic, readonly) PSResolveLayerX *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) PSResolveLayerX *(^toBottom)(CALayer *relatedLayer);/**< 在下侧 */
@property (nonatomic, readonly) PSResolveLayerX *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */

@property (nonatomic, readonly) PSResolveLayerX *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerX *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerX *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerX *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerX *alignParentCenterHeight;/**< 父Layer竖下居中 */

- (void)apply;
@end

@interface PSResolveLayerX : NSObject
@property (nonatomic, readonly) PSResolveLayerX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) PSResolveLayerX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignLeftL;/**< 与上一个relatedLayer左对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignRightL;/**< 与上一个relatedLayer右对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignCenterWidthL;/**< 与上一个related横向居中对齐 */

@property (nonatomic, readonly) PSResolveLayerCompleted *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *toLeftL;/**< 在上一个relatedLayer左侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *toRightL;/**< 在上一个relatedLayer右侧 */

@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentCenterWidth;/**< 父Layer横向居中 */

- (void)apply;
@end

@interface PSResolveLayerY : NSObject
@property (nonatomic, readonly) PSResolveLayerY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) PSResolveLayerY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignTopL;/**< 与上一个relatedLayer上对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignBottomL;/**< 与上一个relatedLayer下对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignCenterHeightL;/**< 与上一个relatedLayer竖向居中对齐 */

@property (nonatomic, readonly) PSResolveLayerCompleted *(^toTop)(CALayer *relatedLayer);/**< 上侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *toTopL;/**< 在上一个relatedLayer上侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *(^toBottom)(CALayer *relatedLayer);/**< 下侧 */
@property (nonatomic, readonly) PSResolveLayerCompleted *toBottomL;/**< 在上一个relatedLayer下侧 */

@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) PSResolveLayerCompleted *alignParentCenterHeight;/**< 父Layer竖向居中 */

- (void)apply;
@end

@interface PSResolveLayerCompleted : NSObject
@property (nonatomic, readonly) PSResolveLayerCompleted *(^distance)(CGFloat distance);

- (void)apply;
@end

@interface CALayer (Layout)
@property (nonatomic, assign) CGFloat ps_x;
@property (nonatomic, assign) CGFloat ps_y;
@property (nonatomic, assign) CGFloat ps_width;
@property (nonatomic, assign) CGFloat ps_height;
@property (nonatomic, assign) CGSize ps_size;
@property (nonatomic, assign) CGPoint ps_location;
@end
NS_ASSUME_NONNULL_END