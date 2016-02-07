//
//  NSString+Kit.m
//  PSKit
//
//  Created by PoiSon on 15/9/21.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import "PSFoudation.h"

@implementation NSString (Kit)
+ (NSString *)ps_randomStringWithLenght:(NSUInteger)lenght{
    char data[lenght];
    for (int x=0;x<lenght;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:lenght encoding:NSUTF8StringEncoding];
}

- (BOOL)ps_containsString:(NSString *)aString{
    return [self rangeOfString:aString].location != NSNotFound;
}
- (BOOL)ps_isEquals:(NSString *)anotherString{
    return [self compare:anotherString] == NSOrderedSame;
}
- (BOOL)ps_isEqualsIgnoreCase:(NSString *)anotherString{
    return [self compare:anotherString options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

- (NSInteger)ps_indexOfChar:(unichar)ch{
    return [self ps_indexOfChar:ch fromIndex:0];
}
- (NSInteger)ps_indexOfChar:(unichar)ch fromIndex:(NSInteger)index{
    NSUInteger len = self.length;
    for (NSInteger i = index; i < len; i++) {
        if (ch == [self characterAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}
- (NSInteger)ps_indexOfString:(NSString *)str{
    return [self rangeOfString:str].location;
}
- (NSInteger)ps_indexOfString:(NSString *)str fromIndex:(NSInteger)index{
    return [self rangeOfString:str options:NSLiteralSearch range:NSMakeRange(index, self.length)].location;
}
- (NSInteger)ps_lastIndexOfChar:(unichar)ch{
    return [self ps_lastIndexOfChar:ch fromIndex:self.length - 1];
}
- (NSInteger)ps_lastIndexOfChar:(unichar)ch fromIndex:(NSInteger)index{
    PSAssert(self.length > index, @"index is out of length");
    NSUInteger len = index;
    for (NSInteger i = len - 1; i >= 0; i --) {
        if (ch == [self characterAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}
- (NSInteger)ps_lastIndexOfString:(NSString *)str{
    return [self rangeOfString:str options:NSBackwardsSearch].location;
}
- (NSInteger)ps_lastIndexOfString:(NSString *)str fromIndex:(NSInteger)index{
    return [self rangeOfString:str options:NSBackwardsSearch range:NSMakeRange(0, index)].location;
}
- (NSString *)ps_substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    return [self substringWithRange:NSMakeRange(from, to - from)];
}
- (NSString *)ps_substringFromIndex:(NSUInteger)from lenght:(NSUInteger)length{
    return [self substringWithRange:NSMakeRange(from, length)];
}

- (NSString *)ps_toLowerCase{
    return [self lowercaseString];
}
- (NSString *)ps_toUpperCase{
    return [self uppercaseString];
}
- (NSString *)ps_firstCharToLowerCase{
    NSString *firstChar = [self substringToIndex:1];
    NSString *otherChars = [self substringFromIndex:1];
    return [[firstChar lowercaseString] stringByAppendingString:otherChars];
}

- (NSString *)ps_firstCharToUpperCase{
    NSString *firstChar = [self substringToIndex:1];
    NSString *otherChars = [self substringFromIndex:1];
    return [[firstChar uppercaseString] stringByAppendingString:otherChars];
}
- (NSString *)ps_trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
}
- (NSString *)ps_replaceAll:(NSString *)origin with:(NSString *)replacement{
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

- (NSString *)ps_removePrefix:(NSString *)prefix{
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:prefix.length];
    }else{
        return self;
    }
}

- (NSString *)ps_removeSuffix:(NSString *)suffix{
    if ([self hasSuffix:suffix]) {
        return [self substringToIndex:self.length - suffix.length];
    }else{
        return self;
    }
}

- (NSArray<NSString *> *)ps_split:(NSString *)separator{
    return [self componentsSeparatedByString:separator];
}

- (NSUInteger)ps_timesAppeard:(NSString *)aString{
    return [self componentsSeparatedByString:aString].count - 1;
}
@end



@implementation NSMutableString (Kit)
- (NSMutableString *)ps_appendString:(NSString *)aString{
    [self appendString:aString];
    return self;
}

- (NSMutableString *)ps_appendFormat:(NSString *)format, ...{
    va_args(format);
    [self appendString:[[NSString alloc] initWithFormat:format arguments:format_args]];
    return self;
}

- (NSMutableString *)ps_subMutableStringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    [self ps_subMutableStringToIndex:to];
    [self ps_subMutableStringFromIndex:from];
    return self;
}

- (NSMutableString *)ps_subMutableStringToIndex:(NSUInteger)to{
    [self deleteCharactersInRange:NSMakeRange(to, self.length - to)];
    return self;
}

- (NSMutableString *)ps_subMutableStringFromIndex:(NSUInteger)from{
    [self deleteCharactersInRange:NSMakeRange(0, from)];
    return self;
}
@end

NSString *NSStringFromUTF8(const char *utf8){
    return [NSString stringWithUTF8String:utf8];
}
