//
//  PSDelayInvocation.h
//  PSKit
//
//  Created by PoiSon on 16/1/14.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSDelayInvocation : NSObject
@property (nonatomic, assign) NSTimeInterval delay;/**< 间隔时间 */

- (id)prepareWithTarget:(id)target;
@end
