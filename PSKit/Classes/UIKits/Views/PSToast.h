//
//  PSToast.h
//  PSKit
//
//  Created by PoiSon on 15/11/18.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSUInteger const PSToastLengthShort;/**< 2 seconds */
extern NSUInteger const PSToastLengthLong;/**< 4 seconds */

NS_ASSUME_NONNULL_BEGIN
@interface PSToast : NSObject
@property (nonatomic, nullable, copy) NSString *text;/**< the message to show. */
@property (nonatomic, nullable, strong) UIView *view;/**< the view to show. */
@property (nonatomic, assign) NSUInteger duration;/**< how long to show the toast for. */
@property (nonatomic, assign) CGFloat position;/**< where to show the toast at. */

+ (instancetype)toastWithText:(NSString *)text duration:(NSUInteger)duration;/**< make a toast. */
+ (instancetype)toastWithView:(UIView *)view duration:(NSUInteger)duration;/**< make a toast. */
+ (instancetype)toastWithText:(NSString *)text andView:(UIView *)view duration:(NSUInteger)duration;/**< make a toast. */

- (void)show;/**< show toast. */
@end
NS_ASSUME_NONNULL_END