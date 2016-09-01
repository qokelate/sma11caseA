//
//  NSDictionary+SC.m
//  sma11case
//
//  Created by sma11case on 8/30/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "NSDictionary+SC.h"
#import "../Macros.h"
#import "NSArray+SC.h"
#import "NSObject+SC.h"
#import "../Functions.h"
#import "NSString+SC.h"

#undef UseExpeAPI
#define UseExpeAPI 1UL

@interface NSArray (sma11case_ShareClass_Internal)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level mustNil:(id)mustNil;
@end

@implementation NSDictionary (sma11case_ShareClass)
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
    [temp appendString:@"{\n"];

    char *buffer = makeCharacterWithCount(prefix.length + IdentSpace, ' ');
    if (self.count) {
        for (NSObject *key in self.allKeys) {
            NSObject *obj = self[key];

            if (IsKindOfClass(key, NSArray)) {
                [temp appendFormat:@"%s", buffer];
                [FType(NSArray *, key) descriptionWithLocale:locale indent:level + 1 mustNil:temp];
                [temp appendString:@" : "];
            } else if (IsKindOfClass(key, NSDictionary)) {
                [temp appendFormat:@"%s", buffer];
                [FType(NSDictionary *, key) descriptionWithLocale:locale indent:level + 1 mustNil:temp];
                [temp appendString:@" : "];
            } else if (IsKindOfClass(key, NSString)) {
                [temp appendFormat:@"%s\"%@\" : ", buffer, key];
            } else {[temp appendFormat:@"%s%@ : ", buffer, key]; }

            if (IsKindOfClass(obj, NSArray)) {
                [FType(NSArray *, obj) descriptionWithLocale:locale indent:level + 2 mustNil:temp];
                [temp appendString:@",\n"];
            } else if (IsKindOfClass(obj, NSDictionary)) {
                [FType(NSDictionary *, obj) descriptionWithLocale:locale indent:level + 2 mustNil:temp];
                [temp appendFormat:@",\n"];
            } else if (IsKindOfClass(obj, NSString)) {
                [temp appendFormat:@"\"%@\",\n", obj];
            } else {[temp appendFormat:@"%@,\n", obj]; }
        }

        [temp replaceCharactersInRange:NSMakeRange(temp.length - 2, 2) withString:@"\n"];
    }
    
    if (level)
    {
        buffer[prefix.length] = 0;
        [temp appendFormat:@"%s", buffer];
    }

    [temp appendString:@"}"];
    
    if (buffer) {
        free(buffer);
    }

    return temp;
}
#endif
@end