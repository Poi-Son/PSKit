//
//  UIView+Kit.h
//  PSKit
//
//  Created by v on 15/9/25.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSKit/NSObject_Kit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (Kit)
+ (instancetype)ps_instanceWithNibName:(nullable NSString *)nibNameOrNil bundel:(nullable NSBundle *)nibBundleOrNil;/**< 使用xib初始化. */

@property (nonatomic, nullable) id ps_tag; /**< 使用Strong策略保存Tag值 */
- (void)setPs_tag:(id)ps_tag useStorePolicy:(PSStorePolicy)plolicy; /**< 使用相关策略保存Tag值 */

- (void)ps_clearSubviews; /**< 清除所有子视图 */
- (__kindof UIViewController *)ps_viewController;/**< 查找包含此View的Controller. */
- (UIImage *)ps_snapshot;/**< 截图. */
- (void)ps_bringSelfToFront;/**< 使当前View在父View中前置. */
- (NSArray<__kindof UIView *> *)ps_findSubviewsWithType:(Class)viewType;/**< 递归寻找类型为viewType的subview. */
- (nullable __kindof UIView *)ps_findFirstSubviewWithType:(Class)viewType;/**< 递归导找类型为viewType的subview, 找到第一个时返回. */
@end
NS_ASSUME_NONNULL_END