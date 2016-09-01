//
//  NSArray+SC.m
//  sma11case
//
//  Created by sma11case on 11/5/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSArray+SC.h"
#import "../Macros.h"
#import "../Functions.h"
#import "NSObject+SC.h"
#include "NSString+SC.h"

#undef UseExpeAPI
#define UseExpeAPI 1UL

@interface NSDictionary (sma11case_ShareClass_Internal)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level mustNil:(id)mustNil;
@end

@implementation NSArray (sma11case_ShareClass)
- (NSData *)toData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)toJsonString
{
    NSString    *jsonStr = nil;
    NSData      *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    
    if (!jsonData) {
        return nil;
    }
    
    jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

#if UseExpeAPI
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self descriptionWithLocale:locale indent:level mustNil:nil];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level mustNil:(id)mustNil
{
    NSMutableString *temp = mustNil;

    if (nil == temp) {
        temp = [NSMutableString stringWithCapacity:StringBufferLength];
    }

    NSString *prefix = [temp regexpFirstMatch:@"[^\\r\\n]+$"];
    [temp appendString:@"(\n"];

    char *buffer = makeCharacterWithCount(prefix.length + IdentSpace, ' ');
    if (self.count) {
        for (NSObject *obj in self) {
            if (IsKindOfClass(obj, NSArray)) {
                [temp appendFormat:@"%s", buffer];
                [FType(NSArray *, obj) descriptionWithLocale:locale indent:level + 1 mustNil:temp];
                [temp appendString:@",\n"];
            } else if (IsKindOfClass(obj, NSDictionary)) {
                [temp appendFormat:@"%s", buffer];
                [FType(NSDictionary *, obj) descriptionWithLocale:locale indent:level + 1 mustNil:temp];
                [temp appendString:@",\n"];
            } else if (IsKindOfClass(obj, NSString)) {
                [temp appendFormat:@"%s\"%@\",\n", buffer, obj];
            } else {[temp appendFormat:@"%s%@,\n", buffer, obj]; }
        }

        [temp replaceCharactersInRange:NSMakeRange(temp.length - 2, 2) withString:@"\n"];
    }

    if (level)
    {
        buffer[prefix.length] = 0;
        [temp appendFormat:@"%s", buffer];
    }
    
    [temp appendString:@")"];
    
    if (buffer) {
        free(buffer);
    }

    return temp;
}
#endif
@end