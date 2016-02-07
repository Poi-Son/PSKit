//
//  PSFile.m
//  PSKit
//
//  Created by PoiSon on 15/9/25.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSFile.h"
#import "PSFoudation.h"

NSString * const PSFileErrorDomain = @"cn.yerl.error.PSFile";
NSString * const PSFileErrorKey = @"cn.yerl.error.PSFile.error.key";

@implementation PSFile{
    NSFileManager *_manager;
    NSString *_path;
    NSError *_lastError;
}

+ (PSFile *)fileWithPath:(NSString *)path{
    PSFile *file = [[PSFile alloc] initWithPath:path];
    return file;
}


- (instancetype)initWithPath:(NSString *)path{
    if (self = [super init]) {
        _path = [path copy];
        _manager = [NSFileManager new];
        [_manager changeCurrentDirectoryPath:path];
    }
    return self;
}

#pragma mark - 状态
- (NSString *)path{
    return _path;
}

- (NSURL *)url{
    return [NSURL URLWithString:_path];
}

- (NSString *)name{
    return [self.path lastPathComponent];;
}

- (BOOL)isDirectory{
    BOOL isDirectory;
    [_manager fileExistsAtPath:_path isDirectory:&isDirectory];
    return isDirectory;
}

- (BOOL)isFile{
    return !self.isDirectory;
}

- (BOOL)isExists{
    return [_manager fileExistsAtPath:_path isDirectory:nil];
}

- (BOOL)delete{
    NSError *error = nil;
    BOOL result = [_manager removeItemAtPath:_path error:&error];
    _lastError = error;
    return result;
}

- (BOOL)clear{
    NSError *error = nil;
    BOOL isDirector = self.isDirectory;
    BOOL result = [_manager removeItemAtPath:_path error:&error];
    _lastError = error;
    if (_lastError == nil && isDirector) {
        [self createIfNotExists];
    }
    return result;
}

- (long long)size{
    if (self.isFile) {
        return [_manager attributesOfItemAtPath:_path error:nil].fileSize;
    }else{
        long long size =0;
        for (PSFile *child in self.childs) {
            size += child.size;
        }
        return size;
    }
}
#pragma mark - 进入/返回文件夹
- (PSFile *)root{
    return [PSFile home];
}

- (PSFile *)parent{
    NSString *parentPath = [_path stringByDeletingLastPathComponent];
    PSAssert(!(![parentPath isEqualToString:NSHomeDirectory()] && [NSHomeDirectory() ps_containsString:parentPath]), @"PSFile: path is out of sandbox.\npath: %@", parentPath);
    return [PSFile fileWithPath:parentPath];
}

- (PSFile *)child:(NSString *)name{
    return [PSFile fileWithPath:[_path stringByAppendingPathComponent:name]];
}

- (NSArray<PSFile *> *)childs{
    NSError *error = nil;
    NSArray<NSString *> *directories = [_manager contentsOfDirectoryAtPath:_path error:&error];
    if (error) {
        return nil;
    }
    
    NSMutableArray<PSFile *> *files = [NSMutableArray new];
    [directories enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [files addObject:[[PSFile alloc] initWithPath:[_path stringByAppendingPathComponent:obj]]];
    }];
    
    return files;
}

#pragma mark - 读取与写入
- (BOOL)createIfNotExists{
    if (self.isExists) {
        return YES;
    }else{
        NSError *error = nil;
        BOOL result = [_manager createDirectoryAtPath:_path
                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:&error];
        _lastError = error;
        return result;
    }
}

- (NSData *)data{
    return [NSData dataWithContentsOfFile:_path];
}

- (PSFile *)write:(NSData *)data withName:(NSString *)name{
    PSAssertParameter(data != nil && name != nil && name.length > 0);
    [self createIfNotExists];
    
    NSString *targetFile = [_path stringByAppendingPathComponent:name];
    [data writeToFile:targetFile atomically:YES];
    return [[PSFile alloc] initWithPath:targetFile];
}

- (BOOL)copyFile:(PSFile *)oldFile toPath:(PSFile *)newFile{
    PSAssertParameter(oldFile != nil && newFile != nil && ![oldFile isEqualToFile:newFile]);
    
    if (!oldFile.isExists) {
        _lastError = [NSError errorWithDomain:PSFileErrorDomain code:-1001 userInfo:@{PSFileErrorKey: @"oldFile is not exists."}];
        return NO;
    }
    [[newFile parent] createIfNotExists];
    
    NSError *error = nil;
    BOOL result = [_manager copyItemAtPath:oldFile.path toPath:newFile.path error:&error];
    _lastError = error;
    return result;
}

- (BOOL)moveFile:(PSFile *)oldFile toPath:(PSFile *)newFile{
    PSAssertParameter(oldFile != nil && newFile != nil && ![oldFile isEqualToFile:newFile]);
    
    if (!oldFile.isExists) {
        _lastError = [NSError errorWithDomain:PSFileErrorDomain code:-1001 userInfo:@{PSFileErrorKey: @"oldFile is not exists."}];
        return NO;
    }
    [[newFile parent] createIfNotExists];
    
    NSError *error = nil;
    BOOL result = [_manager moveItemAtPath:oldFile.path toPath:newFile.path error:&error];
    _lastError = error;
    return result;
}

#pragma mark - 错误
- (NSError *)lastError{
    return _lastError;
}

#pragma mark - orverride
- (NSString *)description{
    return format(@"<PSFile: %p>:\n{\n   type: %@,\n   path: %@\n}", self, self.isDirectory ? @"Directory" : @"File", _path);
}

- (NSString *)debugDescription{
    return format(@"<PSFile: %p>:\n{\n   type: %@,\n   path: %@\n}", self, self.isDirectory ? @"Directory" : @"File", _path);
}

- (BOOL)isEqualToFile:(PSFile *)otherFile{
    return [self.path isEqualToString:otherFile.path];
}
@end

@implementation PSFile (PSAppDirectory)
+ (PSFile *)home{
    return [PSFile fileWithPath:NSHomeDirectory()];
}

+ (PSFile *)caches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return [PSFile fileWithPath:cachesDir];
}

+ (PSFile *)documents{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [PSFile fileWithPath:docDir];
}

+ (PSFile *)tmp{
    return [PSFile fileWithPath:NSTemporaryDirectory()];
}
@end
