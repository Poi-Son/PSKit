//
//  UITableView+PSKit.m
//  PSKit
//
//  Created by PoiSon on 16/2/23.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import "UITableView_Kit.h"
#import "PSFoudation.h"

@implementation UITableView (PSKit)
- (void)ps_registerClassForCell:(Class)cellClass{
    cellClass = cellClass ?: [UITableViewCell class];
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (UITableViewCell *)ps_dequeueReusableCellWithClass:(Class)cellClass{
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
}
@end
