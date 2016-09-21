//
//  NSString+Crypt.m
//  sma11case
//
//  Created by sma11case on 15/4/20.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "NSString+SC.h"
#import <zlib.h>
#import <CommonCrypto/CommonCrypto.h>
#import "../Functions.h"
#import "../Encrypt/Encrypt.h"
#import "../Objects/DebugHelper.h"
#import "../Macros.h"
#import "NSDate+SC.h"
#import "NSObject+SC.h"

const NSRegularExpressionOptions kRegexpDefaultOptions = NSRegularExpressionDotMatchesLineSeparators;

@implementation NSString (sma11case_ShareClass)

+ (NSString *)generateUUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}

- (NSString *)lastPathFileName
{
    return [[self lastPathComponent] regexpReplace:@"\\.[^\\.]+$" replace:@""];
}

- (NSString *)relativePathWithRoot: (NSString *)root to: (NSString *)to
{
    if (0 == root.length)
    {
        root = getCommonRootPath(self, to);
        if (0 == root.length) return nil;
        NSString *eax = [self relativePathWithRoot:root to:to];
        NSString *ebx = [NSString stringWithFormat:@"%@/%@", root, eax];
        return ebx;
    }
    
    NSString *from = self;
    NSString *expr = nil;
    if ([@"/" isEqualToString:root]) expr = @"^/";
    else expr = [NSString stringWithFormat:@"^%@[\\/]+", [NSRegularExpression escapedPatternForString:root]];
    
    NSString *f = [from regexpReplace:expr replace:@""];
    NSString *t = [to regexpReplace:expr replace:@""];
    
    if (f.length == from.length || t.length == to.length) return nil;
    
    NSUInteger fc = [f regexpMatchResults:@"[\\/]+"].count;
    if (0 == fc) return t;
    
    NSMutableString *string = NewMutableString();
    
    [string appendString:[f regexpReplace:@"[\\/][^\\/]+$" replace:@"/"]];
    for (size_t a = 0; a < fc; ++a)
    {
        [string appendString:@"../"];
    }
    [string appendString:t];
    
    return string;
}

- (CGSize)calcSizeWithFont: (CPFont *)font width: (CGFloat)width height: (CGFloat)height
{
    const NSUInteger mode = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    return [self boundingRectWithSize:CGSizeMake(width, height) options:mode attributes:@{NSForegroundColorAttributeName : font} context:NULL].size;
}

- (id)toJSONObject
{
    if (self.length == 0) return nil;
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
}

- (NSDictionary *)toDictionary
{
    NSDictionary *temp = [self toJSONObject];
    if (IsKindOfClass(temp, NSDictionary)) return temp;
    return nil;
}

- (NSArray *)toArray
{
    NSArray *temp = [self toJSONObject];
    if (IsKindOfClass(temp, NSArray)) return temp;
    return nil;
}

- (BOOL)regexpCheck: (NSString *)expression
{
    if (self.length == 0) return NO;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:expression options:kRegexpDefaultOptions error:NULL];
    
    NSTextCheckingResult* match = [reg firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (match.range.length) return YES;
    return NO;
}

- (NSArray *)regexpMatchResults: (NSString *)expression
{
    NSError* error = nil;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:expression options:kRegexpDefaultOptions error:&error];
    if (error) return nil;
    
    NSArray* match = [reg matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return match;
}

- (NSArray *)regexpMatch: (NSString *)expression
{
    NSArray* match = [self regexpMatchResults:expression];
    
    if (0 == match.count) return nil;
    
    NSMutableArray *temp = NewMutableArray();
    for (NSTextCheckingResult *result in match)
    {
        NSString *buffer = [self substringWithRange:result.range];
        [temp addObject:buffer];
    }
    
    return temp;
}

- (NSString *)regexpFirstMatch: (NSString *)expression
{
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:expression options:kRegexpDefaultOptions error:NULL];
    
    NSTextCheckingResult* match = [reg firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (nil == match) return nil;
    
    return [self substringWithRange:match.range];
}

- (NSString *)regexpReplace: (NSString *)expression replace: (NSString *)replace
{
    if (self.length == 0) return nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:kRegexpDefaultOptions error:NULL];
    
    NSArray *result = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (0 == result.count) return self;
    
    NSMutableString *output = nil;
    NSUInteger pass = 0;
    NSUInteger get = 0;
    
    {
        NSUInteger count = 0;
        for (NSTextCheckingResult *rs in result)
        {
            get = rs.range.location - pass;
            pass = rs.range.location + rs.range.length;
            count += replace.length + get;
        }
        
        count += self.length - pass;
        
        if (0 == count) return self;
        output = [NSMutableString stringWithCapacity:count + sizeof(long)];
        
        pass = 0;
    }
    
    for (NSTextCheckingResult *rs in result)
    {
        get = rs.range.location - pass;
        NSString *buffer = [self substringWithRange:NSMakeRange(pass, get)];
        [output appendString:buffer];
        [output appendString:replace];
        pass = rs.range.location + rs.range.length;
    }
    
    get = self.length - pass;
    NSString *buffer = [self substringWithRange:NSMakeRange(pass, get)];
    [output appendString:buffer];
    
    return output;
}

- (NSString *)crc32
{
#if PLAT_IOS
    typedef uInt UInt;
#endif
    unsigned int crc = (unsigned int)crc32(0L, Z_NULL, 0);
    const void *ptr = (void *)self.UTF8String;
    UInt len = (UInt)strlen((char *)ptr);
    crc = (unsigned int)crc32(crc, (Bytef *)ptr, len);
    return [NSString stringWithFormat:@"%08x", crc];
}

- (NSString *)md5
{
    if (self.length == 0) return nil;
    
    const char* utfStr = self.UTF8String;
    unsigned char md[16] = {0};
    CC_MD5(utfStr,(CC_LONG)strlen(utfStr),md);
    char szOutput[33] = { 0 };
    for (int index = 0; index < 16; index++)
    {
        unsigned char src = md[index];
        sprintf(szOutput, "%s%02x",szOutput,src);
    }
    return [NSString stringWithUTF8String:szOutput];
}

- (NSString *)sha1
{
    if (self.length == 0) return nil;
    
    const char* utfStr = self.UTF8String;
    unsigned char md[20] = {0};
    CC_SHA1(utfStr,(CC_LONG)strlen(utfStr),md);
    char szOutput[41] = { 0 };
    for (int index = 0; index < 20; index++)
    {
        unsigned char src = md[index];
        sprintf(szOutput, "%s%02x",szOutput,src);
    }
    return [NSString stringWithUTF8String:szOutput];
}

- (NSData *)base64Decode
{
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

- (NSData *)AESEncryptWithKey:(NSString *)key bit:(AESEncryptBitCount)bit
{
    if (self.length == 0) return nil;
    
    NSData *keyBytes = [key dataUsingEncoding:NSUTF8StringEncoding];
    char *dstBytes = NULL;
    NSUInteger dstSize = cryptor_aes_encrypt(self.UTF8String, self.length, &dstBytes, keyBytes.bytes, bit);
    
    NSData *dstData = nil;
    if (dstSize > 0)
    {
        dstData = [NSData dataWithBytes:dstBytes length:dstSize];
        free(dstBytes);
        dstBytes = NULL;
    }
    return dstData;
}

- (NSString *)AESEncryptToHexStringWithKey:(NSString *)key bit:(AESEncryptBitCount)bit
{
    if (self.length == 0) return nil;
    
    NSData *keyBytes = [key dataUsingEncoding:NSUTF8StringEncoding];
    char *dstBytes = NULL;
    NSUInteger dstSize = cryptor_aes_encrypt(self.UTF8String, self.length, &dstBytes, keyBytes.bytes, bit);
    
    NSString *strHex = nil;
    if(dstSize > 0)
    {
        // 一个字节转成16机制模式存储在字符串里占用两个字节，加多一个字节用来存放字符串的结束标记符'\0'
        NSUInteger mSize = (dstSize * 2) + 1;
        char *szHex = (char*)malloc(mSize);
        memset(szHex, 0, mSize);
        
        for (int i = 0; i < dstSize ; i++)
        {
            unsigned char src = dstBytes[i];
            sprintf(szHex, "%s%02x",szHex,src);
        }
        strHex = [NSString stringWithUTF8String:szHex];
        
        free(szHex);
        szHex = NULL;
        free(dstBytes);
        dstBytes = NULL;
    }
    
    return strHex;
}


- (BOOL)isNumber
{
    return [self regexpCheck:@"^\\d+$"];
}

- (BOOL)isLowercaseString
{
    return [self regexpCheck:@"^[a-z]+$"];
}

- (BOOL)isUppercaseString
{
    return [self regexpCheck:@"^[A-Z]+$"];
}

- (NSData *)toUTF8Data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString*)getNowTimeString: (NSString *)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:format];
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)randomStringWithKeys: (char *)keys length: (size_t)length
{
    return [self randomStringWithKeysEx:keys length:length type:TextCharTypeASCII];
}

+ (NSString *)randomStringWithKeysEx: (char *)keys length: (size_t)length type: (TextCharType)type
{
    char *temp = NULL;
    
    switch (type)
    {
        case TextCharTypeASCII:
            temp = makeRandomString(keys, length);
            break;
            
        case TextCharTypeUTF8CHS:
            temp = (char *)makeRandomStringUTF8CHS((UTF8CHSData *)keys, length);
            break;
    }
    
    NSString *buffer = [[NSString alloc] initWithCString:temp encoding:NSUTF8StringEncoding];
    
    free(temp);
    
    return buffer;
}

+ (unsigned long)toUnsignedLongValue: (NSString *)string
{
    if (0 == string.length) return 0;
    
    NSString *input = string;
    if ([input hasPrefix:@"0x"])
    {
        if (input.length > (sizeof(long)*2+2)) input = [string substringWithRange:NSMakeRange(2, sizeof(long)*2)];
        else input = [string substringFromIndex:2];
    }
    else if ([input hasPrefix:@"#"])
    {
        if (input.length > (sizeof(long)*2+1)) input = [string substringWithRange:NSMakeRange(1, sizeof(long)*2)];
        else input = [string substringFromIndex:1];
    }
    
    return hexStringToUnsignedLongValue(input.UTF8String);
}
@end
