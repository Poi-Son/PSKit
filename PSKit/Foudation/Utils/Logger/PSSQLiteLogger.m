//
//  PSSQLiteLogger.m
//  PSKit
//
//  Created by PoiSon on 15/9/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

//#import "PSSQLiteLogger.h"
//#import "PSFoudation.h"
//
//@implementation PSSQLiteLogger
//
//- (instancetype)initWithDatasource:(NSString *)datasource{
//    PSAssert(datasource.length > 0, @"Set up the sqlite file where to store. It will create when file is not exist.");
//    
//    if (self = [super init]) {
//        PSDicRecord *loggerRecord = [[PSDicRecord alloc] initWithDatasource:datasource forConfig:@"PSSQLiteLoggerConfig"];
//        [loggerRecord registerModel:PSLogRecord.class];
//        [loggerRecord start];
//    }
//    return self;
//}
//
//- (instancetype)init{
//    return [self initWithDatasource:[[[PSFile documents] child:@"Log"] child:@"PSSqliteLog.db"].path];
//}
//
//- (void)logLevel:(PSLogLevel)level func:(const char *)func file:(const char *)file line:(NSInteger)line message:(NSString *)msg{
//    PSLogRecord *newRecord = [PSLogRecord new];
//    newRecord.level = level;
//    newRecord.function = @(func);
//    newRecord.file = format(@"%@: %@", [@(file) lastPathComponent], @(line));
//    newRecord.message = msg;
//    newRecord.create_at = [NSDate date];
//    [newRecord save];
//}
//
//- (NSArray<PSLogRecord *> *)allLogs{
//    return [[PSLogRecord dao] findAll];
//}
//
//- (NSArray<PSLogRecord *> *)logsBetween:(NSDate *)begin and:(NSDate *)end{
//    return [[PSLogRecord dao] findByCondition:@"create_time > ? and create_time < ?", begin, end];
//}
//@end
//
//@implementation PSLogRecord
//@dynamic level;
//@dynamic function;
//@dynamic file;
//@dynamic message;
//@dynamic create_at;
//@end