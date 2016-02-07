//
//  ps-runtime.h
//  PSKit
//
//  Created by PoiSon on 15/12/15.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>
/**
 *  To get the instance of class method exclude superclass
 *
 *  @param cls  The class you want to inspect.
 *  @param sel  A pointer of type \c SEL. Pass the selector of the method you want to retrieve.
 *
 *  @return A pointer to the \c Method data
 */
extern Method ps_class_getInstanceMethod(Class cls, SEL sel);

/**
 *  To get the class method exclude superclass
 *
 *  @param cls  The class you want to inspect.
 *  @param sel A pointer of type \c SEL. Pass the selector of the method you want to retrieve.
 *
 *  @return A pointer to the \c Method data
 */
extern Method ps_class_getMethod(Class cls, SEL sel);