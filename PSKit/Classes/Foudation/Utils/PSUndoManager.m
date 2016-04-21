//
//  PSUndoManager.m
//  PSKit
//
//  Created by PoiSon on 16/1/8.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import "PSUndoManager.h"
#import "PSFoudation.h"

@interface PSUndoAction : NSObject
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, copy) NSArray<NSInvocation *> *invocations;
- (void)action;
@end

@interface PSUndoProxy : NSProxy
@property (nonatomic, strong) id target;
@property (nonatomic, copy) void (^recordCompleted)(NSInvocation *invocation);
@end

@implementation PSUndoManager{
    NSMutableArray<PSUndoAction *> *_undoStack;
    NSMutableArray<PSUndoAction *> *_redoStack;
    
    BOOL _undoing;
    BOOL _redoing;
    
    NSMutableArray<NSInvocation *> *_undoGrouping;
}
- (NSMutableArray<PSUndoAction *> *)redoStack{
    return _redoStack ?: (_redoStack = [NSMutableArray new]);
}
- (NSMutableArray<PSUndoAction *> *)undoStack{
    return _undoStack ?: (_undoStack = [NSMutableArray new]);
}

- (NSMutableArray<NSInvocation *> *)undoGrouping{
    return _undoGrouping;
}

- (void)beginUndoGrouping{
    _undoGrouping = [NSMutableArray new];
}

- (void)endUndoGrouping{
    PSUndoAction *action = [PSUndoAction new];
    action.invocations = _undoGrouping;
    _undoGrouping = nil;
    
    if (self.undoing || self.redoing) {
        if (self.undoing) {
            [self.redoStack addObject:action];
        }else{
            [self.undoStack addObject:action];
        }
        return;
    }
    
    if (_undoGrouping.count > 0) {
        [self.undoStack addObject:action];
        [self.redoStack removeAllObjects];
    }
}

- (void)setActionName:(NSString *)actionName{
    self.undoStack.lastObject.actionName = actionName;
}

- (id)prepareWithTarget:(id)target{
    PSUndoProxy *proxy = [PSUndoProxy alloc];
    proxy.target = target;
    weak(self);
    [proxy setRecordCompleted:^(NSInvocation *invocation) {
        strong(self);
        if (self) {
            if (self.undoGrouping) {
                [self.undoGrouping addObject:invocation];
            }else{
                PSUndoAction *action = [PSUndoAction new];
                action.invocations = @[invocation];
                [self.undoStack addObject:action];
                [self.redoStack removeAllObjects];
            }
        }
    }];
    return proxy;
}

- (NSString *)undoActionName{
    return self.undoStack.lastObject.actionName;
}

- (void)undo{
    returnIf(self.undoStack.count < 1);
    
    _undoing = YES;
    [self beginUndoGrouping];
    
    PSUndoAction *action = [self.undoStack lastObject];
    [action action];
    
    [self endUndoGrouping];
    _undoing = NO;
    
    
    [self.undoStack removeLastObject];
}

- (NSString *)redoActionName{
    return self.redoStack.lastObject.actionName;
}

- (void)redo{
    returnIf(self.redoStack.count < 1);
    
    _redoing = YES;
    [self beginUndoGrouping];
    
    PSUndoAction *action = [self.redoStack lastObject];
    [action action];
    
    [self endUndoGrouping];
    _redoing = NO;
    
    [self.redoStack removeLastObject];
}

- (void)removeAllActions{
    [self.undoStack removeAllObjects];
    [self.redoStack removeAllObjects];
}

- (BOOL)canUndo{
    return self.undoStack.count > 0;
}

- (BOOL)canRedo{
    return self.redoStack.count > 0;
}
@end


@implementation PSUndoProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    if (self.recordCompleted) {
        invocation.target = self.target;
        if (!invocation.argumentsRetained) {
            [invocation retainArguments];
        }
        self.recordCompleted(invocation);
    }
}
@end

@implementation PSUndoAction
- (void)action{
    for (NSInvocation *invocation in self.invocations) {
        [invocation invoke];
    }
}
@end
