//
//  PSBlockInvocation.m
//  PSKit
//
//  Created by PoiSon on 16/2/19.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import "PSBlockInvocation.h"

/**
 *  @see CTObjectiveCRuntimeAdditions https://github.com/ebf/CTObjectiveCRuntimeAdditions
 */
struct __PSBlockLiteral {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct __PSBlock_descriptor {
        unsigned long int reserved;	// NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};

typedef NS_ENUM(NSUInteger, __PSBlockDescriptionFlags) {
    __PSBlockDescriptionFlagsHasCopyDispose = (1 << 25),
    __PSBlockDescriptionFlagsHasCtor = (1 << 26), // helpers have C++ code
    __PSBlockDescriptionFlagsIsGlobal = (1 << 28),
    __PSBlockDescriptionFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    __PSBlockDescriptionFlagsHasSignature = (1 << 30)
};


@implementation PSBlockInvocation{
    NSMethodSignature *_signature;
    NSInvocation *_invocation;
}

+ (instancetype)invocationWithBlock:(id)block{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id)block{
    if (self = [super init]) {
        _signature = _signatureForBlock(block);
        _invocation = [NSInvocation invocationWithMethodSignature:_signature];
        [_invocation setTarget:[block copy]];
    }
    return self;
}

- (NSMethodSignature *)methodSignature{
    return _signature;
}

- (void)getReutrnValue:(void *)retLoc{
    [_invocation getReturnValue:retLoc];
}

- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx{
    [_invocation setArgument:argLoc atIndex:idx];
}

- (void)invoke{
    [_invocation invoke];
}

#pragma mark - block signature
static NSMethodSignature *_signatureForBlock(id block) {
    if (!block)
        return nil;
    
    struct __PSBlockLiteral *blockRef = (__bridge struct __PSBlockLiteral *)block;
    NSUInteger flags = blockRef->flags;
    
    if (flags & __PSBlockDescriptionFlagsHasSignature) {
        void *signatureLocation = blockRef->descriptor;
        signatureLocation += sizeof(unsigned long int);
        signatureLocation += sizeof(unsigned long int);
        
        if (flags & __PSBlockDescriptionFlagsHasCopyDispose) {
            signatureLocation += sizeof(void (*)(void *dst, void *src));
            signatureLocation += sizeof(void (*)(void *src));
        }
        
        const char *signature = (*(const char **)signatureLocation);
        return [NSMethodSignature signatureWithObjCTypes:signature];
    }
    return nil;
}
@end
