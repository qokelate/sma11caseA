//
//  NSData+SC.m
//  sma11case
//
//  Created by sma11case on 9/6/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "NSData+SC.h"

@implementation NSData(sma11case_ShareClass)

- (id)unarchiveData
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

- (id)toJSONObject
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:NULL];
}

- (NSString *)toUTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)toStringWithEncoding: (NSStringEncoding)code
{
    return [[NSString alloc] initWithData:self encoding:code];
}

- (NSString *)base64Encode
{
    NSString *base64String = nil;
    
    if ([self respondsToSelector:@selector(base64EncodedDataWithOptions:)])
    {
        base64String = [self base64EncodedStringWithOptions:0];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        base64String = [self base64Encoding];
#pragma clang diagnostic pop
    }
    
    return base64String;
}
@end
