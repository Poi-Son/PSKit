//
//  PSRefernceCycles.h
//  PSKit
//
//  Created by PoiSon on 15/9/22.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

/**
 *  强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 *  调用方式: `weak`实现弱引用转换，`strong(object)`实现强引用转换
 *
 *  示例：
 *  weak(object)
 *  [obj block:^{
 *      strong(object)
 *      object = something;
 *  }];
 */
#ifndef	weak
    #define weak(object) __weak __typeof__(object) weak##_##object = object;
#endif
#ifndef	strong
    #define strong(object) __typeof__(object) object = weak##_##object;
#endif