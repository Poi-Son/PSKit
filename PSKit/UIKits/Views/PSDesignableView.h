//
//  PSDesignableView.h
//  PSKit
//
//  Created by PoiSon on 15/11/19.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface PSDesignableView : UIView
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@end
NS_ASSUME_NONNULL_END