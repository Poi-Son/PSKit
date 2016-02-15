//
//  NSData_Kit.h
//  PSKit
//
//  Created by PoiSon on 15/11/20.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSData (Kit)
- (NSData *)ps_dataWithTargetEncodingFromUTF8:(NSStringEncoding)targetEncoding;/**< 将UTF8编码的NSData转成目标编码 */
- (NSData *)ps_dataWithUTF8FromEncoding:(NSStringEncoding)fromEncoding;/**< 将目标编码的NSData转成UTF8编码 */
@end


//@interface NSData (PSGZip)
///** gzip压缩 */
//- (NSData *)ps_gzipCompression;
///** gzip解压 */
//- (NSData *)ps_gzipDecompression;
//@end

NS_ASSUME_NONNULL_END