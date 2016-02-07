//
//  PSFileLog.h
//  PSKit
//
//  Created by PoiSon on 15/9/27.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <PSKit/PSKit.h>
NS_ASSUME_NONNULL_BEGIN
@class PSFile;
/**
 *  PSFileLogger
 *  Save log to file. Default save path is Documents/Log
 */
@interface PSFileLogger : NSObject<PSLogger>
/** log file save path. */
@property (nonatomic, readonly, copy) PSFile *savePath;

/** file name formatter. default is yyyy-MM-dd-HH. then it will create file named like yyyy-MM-dd-HH.log */
@property (nonatomic, strong) NSString *fileNameFormatter;

- (instancetype)initWithSavePath:(PSFile *)savePath NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END