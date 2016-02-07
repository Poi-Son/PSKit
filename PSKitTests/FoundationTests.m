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

- (void)testBase64{
    NSString *data = [@"中国人" ps_base64EncodedString];
    XCTAssert([data isEqualToString:@"5Lit5Zu95Lq6"]);
    
    NSData *data2 = [@"5Lit5Zu95Lq6" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssert([[data2 ps_base64DecodedString] isEqualToString:@"中国人"]);
}

- (void)testNSArrayKit{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6"]];
    [array ps_moveObjectAtIndex:5 toIndex:1];
    [array isEqualToArray:@[@"0", @"5", @"1", @"2", @"3", @"4", @"6"]];
    
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6"]];
    [array2 ps_moveObjectAtIndex:1 toIndex:5];
    [array2 isEqualToArray:@[@"0", @"2", @"3", @"4", @"5", @"1", @"6"]];
}
@end
