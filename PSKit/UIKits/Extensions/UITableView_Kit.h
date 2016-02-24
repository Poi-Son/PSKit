//
//  UITableView+PSKit.h
//  PSKit
//
//  Created by PoiSon on 16/2/23.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UITableView (PSKit)
- (void)ps_registerClassForCell:(nullable Class)cellClass;/**< 注册重用cell */
- (nullable __kindof UITableViewCell *)ps_dequeueReusableCellWithClass:(nullable Class)cellClass;/**< 配合ps_registerClassForCell:使用 */
@end

NS_ASSUME_NONNULL_END