//
//  MDLayout.h
//  LayoutTest
//
//  Created by PoiSon on 15/5/14.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSResolveViewX;
@class PSResolveViewY;
@class PSResolveViewComplete;

#define PSLayoutV(view) [PSViewLayout layoutForView:view]

NS_ASSUME_NONNULL_BEGIN
/**
 *  根据frame设置View的位置, 此类不适用于AutoLayout
 */
@interface PSViewLayout : NSObject
+ (instancetype)layoutForView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) PSViewLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) PSViewLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) PSResolveViewY *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) PSResolveViewY *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) PSResolveViewY *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) PSResolveViewY *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) PSResolveViewY *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */

@property (nonatomic, readonly) PSResolveViewY *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewY *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewY *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewY *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewY *alignParentCenterWidth;/**< 父View横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) PSResolveViewX *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) PSResolveViewX *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) PSResolveViewX *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) PSResolveViewX *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) PSResolveViewX *(^alignCenterHeight)(UIView *relatedView);/**< 竖向居中对齐 */

@property (nonatomic, readonly) PSResolveViewX *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewX *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewX *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewX *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewX *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface PSResolveViewX : NSObject
@property (nonatomic, readonly) PSResolveViewX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) PSResolveViewX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) PSResolveViewComplete *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignLeftV;/**< 与上一个relatedView左对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignRightV;/**< 与上一个relatedView右对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignCenterWidthV;/**< 与上一个relatedView横向居中对齐 */

@property (nonatomic, readonly) PSResolveViewComplete *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) PSResolveViewComplete *toLeftV;/**< 在上一个relatedView左侧 */
@property (nonatomic, readonly) PSResolveViewComplete *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) PSResolveViewComplete *toRightV;/**< 在上一个relatedView右侧 */

@property (nonatomic, readonly) PSResolveViewComplete *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewComplete *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewComplete *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewComplete *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewComplete *alignParentCenterWidth;/**< 父View横向居中 */

- (void)apply;
@end

@interface PSResolveViewY : NSObject
@property (nonatomic, readonly) PSResolveViewY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) PSResolveViewY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) PSResolveViewComplete *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignTopV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignBottomV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *(^alignCenterHeight)(UIView *relatedView);/**< 居中对齐 */
@property (nonatomic, readonly) PSResolveViewComplete *alignCenterHeightV;/**< 与上一个relatedView居中对齐 */

@property (nonatomic, readonly) PSResolveViewComplete *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) PSResolveViewComplete *toTopV;/**< 在上一个relatedView上侧 */
@property (nonatomic, readonly) PSResolveViewComplete *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) PSResolveViewComplete *toBottomV;/**< 在上一个relatedView下侧 */

@property (nonatomic, readonly) PSResolveViewComplete *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewComplete *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewComplete *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) PSResolveViewComplete *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) PSResolveViewComplete *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface PSResolveViewComplete : NSObject
@property (nonatomic, readonly) PSResolveViewComplete *(^distance)(CGFloat distance);

- (void)apply;
@end


@interface UIView (Layout)
@property (nonatomic, assign) CGFloat ps_x;/**< view.frame.origin.x */
@property (nonatomic, assign) CGFloat ps_y;/**< view.frame.origin.y */
@property (nonatomic, assign) CGFloat ps_width;/**< view.frame.size.width */
@property (nonatomic, assign) CGFloat ps_height;/**< view.frame.size.height */
@property (nonatomic, assign) CGSize ps_size;/**< view.frame.size */
@property (nonatomic, assign) CGPoint ps_location;/**< view.frame.origin */
@end
NS_ASSUME_NONNULL_END