//
//  PSBase64Encoding.m
//  PSKit
//
//  Created by PoiSon on 15/12/1.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSBase64Encoding.h"

@implementation NSString (PSBase64Encoding)
- (NSData *)ps_base64EncodedData{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSData *)ps_base64DecodedData{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data ps_base64DecodedData];
}

- (NSString *)ps_base64EncodedString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)ps_base64DecodedString{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:kNilOptions];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end


@implementation NSData (PSBase64Encoding)
- (NSString *)ps_base64DecodedString{
    NSData *data = [[NSData alloc] initWithBase64EncodedData:self options:kNilOptions];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)ps_base64EncodedString{
    NSData *data = [self ps_base64EncodedData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)ps_base64EncodedData{
    return [self base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSData *)ps_base64DecodedData{
    return [[NSData alloc] initWithBase64EncodedData:self options:kNilOptions];
}
@end