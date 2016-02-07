//
//  NSString+Kit.h
//  PSKit
//
//  Created by PoiSon on 15/9/21.
//  Copyright (c) 2015年 yerl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define format(format , ...) [NSString stringWithFormat:format, ##__VA_ARGS__]

NS_ASSUME_NONNULL_BEGIN
@interface NSString (Kit)
+ (NSString *)ps_randomStringWithLenght:(NSUInteger)lenght;/**< 随机字符串 */

- (BOOL)ps_containsString:(NSString *)aString;/**< 是否包含字符串 */
- (BOOL)ps_isEquals:(NSString *)anotherString;/**< 大小写敏感比较 */
- (BOOL)ps_isEqualsIgnoreCase:(NSString *)anotherString;/**< 大小写不敏感比较 */

- (NSInteger)ps_indexOfChar:(unichar)ch;/**< 定位字符第一次出现的位置 */
- (NSInteger)ps_indexOfChar:(unichar)ch fromIndex:(NSInteger)index;/**< 定位字符在${index}后第一次出现的位置 */
- (NSInteger)ps_indexOfString:(NSString *)str;/**< 定位字符串第一次出现的位置 */
- (NSInteger)ps_indexOfString:(NSString *)str fromIndex:(NSInteger)index;/**< 定位字符串在${index}后第一次出现的位置 */
- (NSInteger)ps_lastIndexOfChar:(unichar)ch;/**< 从后向前定位字符第一次出现的位置 */
- (NSInteger)ps_lastIndexOfChar:(unichar)ch fromIndex:(NSInteger)index;/**< 从后向前定位字符在${index}之前第一次出现的位置 */
- (NSInteger)ps_lastIndexOfString:(NSString *)str;/**< 从后向前定位字符串第一次出现的位置 */
- (NSInteger)ps_lastIndexOfString:(NSString *)str fromIndex:(NSInteger)index;/**< 从后向前定位字符串在${index}之前第一次出现的位置 */

- (NSString *)ps_substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;/**< 截字符串 */
- (NSString *)ps_substringFromIndex:(NSUInteger)from lenght:(NSUInteger)length;/**< 截取字符串, 从${from}开始, 截取${length}个字符 */
- (NSString *)ps_toLowerCase;/**< 转换成小写 */
- (NSString *)ps_toUpperCase;/**< 转换成大写 */
- (NSString *)ps_firstCharToLowerCase;/**< 第一个字符变大写 */
- (NSString *)ps_firstCharToUpperCase;/**< 第一个字符变小写 */
- (NSString *)ps_trim;/**< 移除前后的空格和回车 */
- (NSString *)ps_replaceAll:(NSString *)origin with:(NSString *)replacement;/**< 替换字符串 */
- (NSString *)ps_removePrefix:(NSString *)prefix;/**< 去掉前缀 */
- (NSString *)ps_removeSuffix:(NSString *)suffix;/**< 去掉后缀 */
- (NSArray<NSString *> *)ps_split:(NSString *)separator;/**< 根据分隔符分隔字符串 */

- (NSUInteger)ps_timesAppeard:(NSString *)aString;/**< 统计字符串出现的次数 */
@end

@interface NSMutableString (Kit)
- (NSMutableString *)ps_appendString:(NSString *)aString;/**< 拼接字符串到后面 */
- (NSMutableString *)ps_appendFormat:(NSString *)format, ...;/**< 拼接字符串到后面 */
- (NSMutableString *)ps_subMutableStringFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;/**< 从${fromIndex}到${toIndex}截取字符串 */
- (NSMutableString *)ps_subMutableStringFromIndex:(NSUInteger)fromIndex;/**< 从${fromIndex}到尾截取字符串 */
- (NSMutableString *)ps_subMutableStringToIndex:(NSUInteger)toIndex;/**< 从头到${toIndex}截取字符串 */
@end

#pragma mark - Encoding
@interface NSString (Encoding)
- (NSString *)ps_URLEncoding;/**< url encode */
- (NSString *)ps_URLDecoding;/**< url decode */
- (NSString *)ps_MD5Encoding;/**< MD5 */
@end

@interface NSString (Encyption)

@end

FOUNDATION_EXPORT NSString *NSStringFromUTF8(const char *utf8);
NS_ASSUME_NONNULL_END