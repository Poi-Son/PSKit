//
//  Kit.h
//  PSKit
//
//  Created by PoiSon on 16/2/29.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSKit/PSKitDefines.h>

PSKIT_EXTERN NSError *NSErrorWithLocalizedDescription(NSString *description);

@interface NSError (PSKit)
+ (instancetype)ps_errorWithLocalizedDescription:(NSString *)description;
@end
