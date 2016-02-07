//
//  PSConsoleLog.m
//  PSKit
//
//  Created by PoiSon on 15/9/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSConsoleLogger.h"
#import "PSFoudation.h"

@implementation PSConsoleLogger
- (void)logLevel:(PSLogLevel)level func:(const char *)func file:(const char *)file line:(NSInteger)line message:(NSString *)msg{
    NSString *prefix;
    switch (level) {
        case PSLogLevelINFO:
            prefix = @"✏️✏️";
            break;
        case PSLogLevelDEBUG:
            prefix = @"🐞🐞";
            break;
        case PSLogLevelWARNING:
            prefix = @"⚠️⚠️";
            break;
        case PSLogLevelERROR:
            prefix = @"❌❌";
            break;
    }
    PSPrintf(@"%@%@ %s (%@: %@)\n%@\n=========================================\n", prefix, [[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], func, [@(file) lastPathComponent], @(line), msg);
}
@end
