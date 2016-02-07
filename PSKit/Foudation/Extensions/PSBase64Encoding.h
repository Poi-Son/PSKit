//
//  PSBase64Encoding.h
//  PSKit
//
//  Created by PoiSon on 15/12/1.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (PSBase64Encoding)
- (NSData *)ps_base64EncodedData;/**< base 64 编码 */
- (NSString *)ps_base64EncodedString;/**< base 64 编码后的字符串 */
- (NSString *)ps_base64DecodedString;/**< base 64 解码后的字符串 */
@end

@interface NSData (PSBase64Encoding)
- (NSString *)ps_base64DecodedString;/**< base 64 解码后的字符串 */
- (NSData *)ps_base64EncodedData;/**< base 64 编码后的二进制 */
- (NSData *)ps_base64DecodedData;/**< base 64 解码后的二进制 */
@end
