//
//  PSUndoManager.h
//  PSKit
//
//  Created by PoiSon on 16/1/8.
//  Copyright © 2016年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUndoManager : NSObject
@property (nonatomic, assign) NSUInteger levelsOfUndo;

- (void)beginUndoGrouping;/**< 开始记录一组动作 */
- (void)endUndoGrouping;/**< 结束记录一组动作 */
- (void)setActionName:(NSString *)actionName;

@property (nonatomic, readonly) NSString *undoActionName;
- (void)undo;/**< 撤消 */

@property (nonatomic, readonly) NSString *redoActionName;
- (void)redo;/**< 重做 */

@property (nonatomic, readonly) BOOL canUndo;
@property (nonatomic, readonly) BOOL canRedo;
@property (nonatomic, readonly) BOOL undoing;/**< 是否正在撤消中 */
@property (nonatomic, readonly) BOOL redoing;/**< 是否正在重做中 */

- (void)removeAllActions;

- (id)prepareWithTarget:(id)target;
@end
