//
//  PSSQLiteLogger.h
//  PSKit
//
//  Created by PoiSon on 15/9/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

//#import <PSKit/PSKit.h>
//#import "PSModel.h"
//
//@protocol PSLogger;
//@class PSLogRecord;
//
///**
// * PSSQLiteLogger
// * Save log to sqlite. Default save path is Documents/Log/PSSqliteLog.db
// */
//@interface PSSQLiteLogger : NSObject<PSLogger>
///** set up the sqlite file where to store. */
//- (instancetype)initWithDatasource:(NSString *)datasource NS_DESIGNATED_INITIALIZER;
//
//- (NSArray<PSLogRecord *> *)allLogs;/**< get all logs. */
//- (NSArray<PSLogRecord *> *)logsBetween:(NSDate *)begin and:(NSDate *)end;/**< logs between ${begin} and ${end} */
//@end
//
///** LogRecord */
//@interface PSLogRecord : PSModel<PSLogRecord *>
//@property (nonatomic, assign) PSLogLevel level;
//@property (nonatomic, strong) NSString *function;
//@property (nonatomic, strong) NSString *file;
//@property (nonatomic, strong) NSString *message;
//@property (nonatomic, retain) NSDate *create_at;
//@end