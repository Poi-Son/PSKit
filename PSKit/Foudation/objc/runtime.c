//
//  ps-runtime.c
//  PSKit
//
//  Created by PoiSon on 15/12/15.
//  Copyright © 2015年 yerl. All rights reserved.
//


#import "runtime.h"
#import <string.h>
#import <stdlib.h>

Method ps_class_getInstanceMethod(Class cls, SEL sel){
    Method result = nil;
    unsigned int mcount;
    Method *mlist = class_copyMethodList(cls, &mcount);
    for (int i = 0; i < mcount; i ++) {
        if (method_getName(mlist[i]) == sel) {
            result = mlist[i];
        }
    }
    free(mlist);
    return result;
}


Method ps_class_getMethod(Class cls, SEL sel){
    Method result = nil;
    unsigned int mcount;
    Method *mlist = class_copyMethodList(object_getClass((id)cls), &mcount);
    for (int i = 0; i < mcount; i ++) {
        if (method_getName(mlist[i]) == sel) {
            result = mlist[i];
        }
    }
    free(mlist);
    return result;
}