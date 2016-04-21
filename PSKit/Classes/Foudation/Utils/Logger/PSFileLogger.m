//
//  PSFileLog.m
//  PSKit
//
//  Created by PoiSon on 15/9/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFileLogger.h"
#import "PSFoudation.h"

@interface PSFileLogger()
@property (nonatomic, copy) NSString *formatter;
@end

@implementation PSFileLogger
- (void)setFileNameFormatter:(NSString *)fileNameFormatter{
    _fileNameFormatter = [fileNameFormatter copy];
    self.formatter = [fileNameFormatter stringByAppendingString:@".log"];
}

- (instancetype)init{
    return [self initWithSavePath:[[PSFile documents] child:@"Log"]];
}

- (instancetype)initWithSavePath:(PSFile *)savePath{
    if (self = [super init]) {
        _savePath = savePath;
        self.fileNameFormatter = @"yyyy-MM-dd-HH";
    }
    return self;
}

- (void)logLevel:(PSLogLevel)level func:(const char *)func file:(const char *)file line:(NSInteger)line message:(NSString *)msg{
    PSFile *logFile = [self.savePath child:[[NSDate new] ps_toString:self.formatter]];
    [[logFile parent] createIfNotExists];
    
    NSMutableData *logData = [NSMutableData dataWithContentsOfFile:logFile.path];
    if (!logData) {
        logData = [NSMutableData new];
    }
    NSString *log = NSStringWithFormat(@"%@ %s (%@: %@)\n%@\n=========================================\n", [[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], func, [@(file) lastPathComponent], @(line), msg);
    [logData appendData:[log dataUsingEncoding:NSUTF8StringEncoding]];
    [logData writeToFile:logFile.path atomically:YES];
}

@end
