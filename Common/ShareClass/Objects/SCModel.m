//
//  SCModel.m
//  sma11case
//
//  Created by sma11case on 15/8/23.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "SCModel.h"
#import "DebugHelper.h"
#import "../Category/Category.h"
#import "../Functions.h"
#import "../IsRootClass.m"
#import <objc/runtime.h>

#define SCLog(...) //MLog(__VA_ARGS__)

MakeStaticChar(gs_cached);

@implementation SCModel
ImpIsRootClass(SCModel)

+ (instancetype)modelWithDictionary: (NSDictionary *)dictionary
{
    id temp = NewClass(self);
    [temp updateWithDictionary:dictionary];
    return temp;
}

- (void)updateWithDictionary: (NSDictionary *)dictionary
{
    NSMutableDictionary *indexs = nil;
    
    {
        id cls = SelfClass;
        BOOL state = [cls cachePropertyList];
        if (state) indexs = objc_getAssociatedObject(cls, &gs_cached);
        
        if (nil == indexs)
        {
            NSDictionary *names = [SelfClass visiablePropertiesListWithEndClass:[SCModel class]];
            
            if (0 == names.count) return;
            
            indexs = NewMutableDictionary();
            for (NSString *key in names.allKeys)
            {
                NSString *attrib = names[key];
                //        if ([attrib hasPrefix:@"T@"]
                //            && NO == StringHasSubstring(attrib, @",&")
                //            && NO == StringHasSubstring(attrib, @",W")) continue;
                if (StringHasSubstring(attrib, @",R,")) continue;
                
                [indexs setObject:key forKey:key.lowercaseString];
            }
            
            if (0 == indexs.count) return;
            
            if (state) objc_setAssociatedObject(cls, &gs_cached, indexs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    for (NSString *key in dictionary.allKeys)
    {
        NSString *wKey = indexs[key.lowercaseString];
        if (0 == wKey.length) continue;
        
        id value = dictionary[key];
        if (IsSCNil(value))
        {
            SCLog(@"setValue: %@ = %@", wKey, value);
            [self setNilValueForKey:wKey];
            continue;
        }
        
        SCLog(@"setValue: %@ = %@", wKey, value);
        [self setValue:value forKey:wKey];
    }
}

- (NSMutableDictionary *)dictionary
{
    return [self propertiesWithEndClass:nil];
}

- (NSMutableDictionary *)dictionaryWithRecursive: (BOOL)recursive
{
    if (IsInstance(self, SCModel)) return nil;
    
    Class cls = (recursive ? [SCModel class] : nil);
    return [self propertiesWithEndClass:cls];
}

- (NSMutableDictionary *)dictionaryWithKeys: (NSArray *)keys
{
    if (IsInstance(self, SCModel)) return nil;
    
    NSDictionary *temp = [self propertiesWithEndClass:[SCModel class]];
    
    NSMutableDictionary *buffer = NewMutableDictionary();
    
    for (NSString *key in keys)
    {
        id obj = temp[key];
        if (nil == obj) continue;
        [buffer setObject:obj forKey:key];
    }
    return buffer;
}

#pragma mark NSCoding 协议
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *props = self.dictionary;
    for (NSString *key in props.allKeys)
    {
        id temp = props[key];
        if (IsSCNil(temp)) continue;
        [aCoder encodeObject:temp forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        NSDictionary *props = self.dictionary;
        
        for (NSString *key in props.allKeys)
        {
            id temp = [aDecoder decodeObjectForKey:key];
            if (IsSCNil(temp))
            {
                [self setNilValueForKey:key];
                continue;
            }
            [self setValue:temp forKey:key];
        }
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

+ (BOOL)cachePropertyList
{
    return YES;
}

- (NSString *)description
{
    NSString *buffer = [self dictionaryWithRecursive:YES].description;
    NSString *temp = [NSString stringWithFormat:@"<%@: %p>\n%@", NSStringFromClass(SelfClass), self, buffer];
    return temp;
}
@end
