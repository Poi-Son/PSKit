//
//  PSDesignableView.m
//  PSKit
//
//  Created by PoiSon on 15/11/19.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSDesignableView.h"

@implementation PSDesignableView

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

@end
