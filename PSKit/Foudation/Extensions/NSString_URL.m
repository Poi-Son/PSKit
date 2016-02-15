//
//  NSString+URL.m
//  PSKit
//
//  Created by PoiSon on 16/2/15.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import "NSString_Kit.h"

@implementation NSString (PS_URL)
-(NSString *)ps_URLEncoding{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString *)ps_URLDecoding{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)ps_URLParamForKey:(NSString *)aKey{
    //先URLDecode
    NSString *decodedURL = [self ps_URLDecoding];
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", aKey];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:kNilOptions
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:decodedURL
                                      options:0
                                        range:NSMakeRange(0, [decodedURL length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [decodedURL substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}
@end