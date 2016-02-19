//
//  FoundationTests.m
//  PSKit
//
//  Created by yan on 16/2/7.
//  Copyright © 2016年 PoiSon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PSKit/PSKit.h>

@interface FoundationTests : XCTestCase

@end

@implementation FoundationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUIColorKit{
    UIColor *redColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    NSString *hexValue = [redColor ps_hexString];
    XCTAssert([hexValue isEqualToString:@"#FF0000"]);
}

- (void)testNSStringKit{
    NSString *originStr = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableString *aStr = [[NSMutableString stringWithString:originStr] ps_subMutableStringToIndex:3];
    XCTAssert([aStr isEqualToString:[originStr substringToIndex:3]]);
    
    NSMutableString *bStr = [[NSMutableString stringWithString:originStr] ps_subMutableStringFromIndex:3];
    XCTAssert([bStr isEqualToString:[originStr substringFromIndex:3]]);
    
    NSMutableString *cStr = [[NSMutableString stringWithString:originStr] ps_subMutableStringFromIndex:3 toIndex:6];
    XCTAssert([cStr isEqualToString:[originStr ps_substringFromIndex:3 toIndex:6]]);
    
    NSMutableString *dStr = [[NSMutableString stringWithString:@"abc"] ps_appendString:@"abc"];
    XCTAssert([dStr isEqualToString:@"abcabc"]);
    
    NSMutableString *eStr = [[NSMutableString stringWithFormat:@"abc"] ps_appendFormat:@"abc%@", @"def"];
    XCTAssert([eStr isEqualToString:@"abcabcdef"]);
}

- (void)testEncrypt{
    NSString *tripleDESEncrypt = [@"中国人" ps_3DESEncryptWithKey:@"123"];
    XCTAssert([tripleDESEncrypt isEqualToString:@"pU32tvXNcA8wHjP//2d+2A=="]);
    
    NSString *tripleDESDecrypt = [@"pU32tvXNcA8wHjP//2d+2A==" ps_3DESDecryptWithKey:@"123"];
    XCTAssert([tripleDESDecrypt isEqualToString:@"中国人"]);
}

- (void)testBase64{
    NSString *DecodedString = @"中国人";
    NSData *DecodedData = [DecodedString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *EncodedString = @"5Lit5Zu95Lq6";
    NSData *EncodedData = [EncodedString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data1 = [DecodedString ps_base64EncodedData];
    XCTAssert([data1 isEqualToData:EncodedData]);
    
    NSData *data2 = [EncodedData ps_base64DecodedData];
    XCTAssert([data2 isEqualToData:DecodedData]);
    
    NSString *string1 = [DecodedString ps_base64EncodedString];
    XCTAssert([string1 isEqualToString:EncodedString]);
    
    NSString *string2 = [EncodedString ps_base64DecodedString];
    XCTAssert([string2 isEqualToString:DecodedString]);
    
    NSString *string3 = [EncodedData ps_base64DecodedString];
    XCTAssert([string3 isEqualToString:DecodedString]);
    
    NSString *string4 = [DecodedData ps_base64EncodedString];
    XCTAssert([string4 isEqualToString:EncodedString]);
    
    NSData *data3 = [EncodedData ps_base64DecodedData];
    XCTAssert([data3 isEqualToData:DecodedData]);
    
    NSData *data4 = [DecodedData ps_base64EncodedData];
    XCTAssert([data4 isEqualToData:EncodedData]);
}

- (void)testNSArrayKit{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6"]];
    [array ps_moveObjectAtIndex:5 toIndex:1];
    [array isEqualToArray:@[@"0", @"5", @"1", @"2", @"3", @"4", @"6"]];
    
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6"]];
    [array2 ps_moveObjectAtIndex:1 toIndex:5];
    [array2 isEqualToArray:@[@"0", @"2", @"3", @"4", @"5", @"1", @"6"]];
}

- (void)testBlockInvocation{
    PSBlockInvocation *invocation = [PSBlockInvocation invocationWithBlock:^(int i, int j, CGRect rect){
        XCTAssertEqual(i, 1);
        XCTAssertEqual(j, 2);
        XCTAssert(CGRectEqualToRect(rect, CGRectMake(0, 0, 0, 0)));
        return CGRectMake(rect.origin.x + i, rect.origin.y + i, rect.size.height + j, rect.size.width + j);
    }];
    
    int a = 1;
    int b = 2;
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    [invocation setArgument:&a atIndex:1];
    [invocation setArgument:&b atIndex:2];
    [invocation setArgument:&rect atIndex:3];
    [invocation invoke];
    
    CGRect result;
    [invocation getReutrnValue:&result];
    
    XCTAssert(CGRectEqualToRect(result, CGRectMake(1, 1, 2, 2)));
}
@end
