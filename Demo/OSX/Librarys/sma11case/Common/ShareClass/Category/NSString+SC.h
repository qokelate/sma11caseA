//
//  NSString+Crypt.h
//  IBOS-IOS
//
//  Created by IBOS on 15/4/20.
//  Copyright (c) 2015年 IBOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../ExternalsSource/ExternalsSource.h"
#import "../CrossPlatform/CrossPlatform.h"

typedef NS_ENUM(NSUInteger, AESEncryptBitCount)
{
    AESEncryptBit128 = 128,
    AESEncryptBit192 = 192,
    AESEncryptBit256 = 256,
};

typedef NS_ENUM(NSUInteger, TextCharType)
{
    TextCharTypeASCII = 1,
    TextCharTypeUTF8CHS = 3,
};

extern const NSRegularExpressionOptions kRegexpDefaultOptions;

@interface NSString (sma11case_ShareClass)
+ (NSString *)generateUUIDString;
+ (NSString*)getNowTimeString: (NSString *)format;


+ (NSString *)randomStringWithKeys: (char *)keys length: (size_t)length;
+ (NSString *)randomStringWithKeysEx: (char *)keys length: (size_t)length type: (TextCharType)type;

- (NSString *)crc32;
- (NSString *)md5;
- (NSString *)sha1;

- (BOOL)isNumber;
- (BOOL)isLowercaseString;
- (BOOL)isUppercaseString;

- (id)toJSONObject;
- (NSData *)toUTF8Data;
+ (unsigned long)toUnsignedLongValue: (NSString *)string;

- (BOOL)regexpCheck: (NSString *)expression;
- (NSArray *)regexpMatchResults: (NSString *)expression;
- (NSArray *)regexpMatch: (NSString *)expression;
- (NSString *)regexpFirstMatch: (NSString *)expression;
- (NSString *)regexpReplace: (NSString *)expression replace: (NSString *)replace;

- (NSData *)base64Decode;
- (NSData *)AESEncryptWithKey:(NSString *)key bit:(AESEncryptBitCount)bit;
- (NSString *)AESEncryptToHexStringWithKey:(NSString *)key bit:(AESEncryptBitCount)bit;

- (CGSize)calcSizeWithFont: (CPFont *)font width: (CGFloat)width height: (CGFloat)height;

- (NSString *)lastPathFileName;
- (NSString *)relativePathWithRoot: (NSString *)root to: (NSString *)to;
@end
