//
//  WeakDictionary.m
//  sma11case
//
//  Created by sma11case on 15/8/19.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "WeakDictionary.h"
#import "../Macros.h"
#import "../Functions.h"
#import "WeakArray.h"
#import "../IsRootClass.m"
#import "../Category/Category.h"

@interface NSArray (sma11case_ShareClass_Internal)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level mustNil:(id)mustNil;
@end

@interface NSDictionary (sma11case_ShareClass_Internal)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level mustNil:(id)mustNil;
@end

@implementation WeakDictionary
{
    NSMutableDictionary *_buffer;
}

+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems
{
    return [[self alloc] initWithCapacity:numItems];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _buffer = [NSMutableDictionary dictionaryWithCapacity:MinMutableCount];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    if (self = [super init])
    {
        _buffer = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    return self;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    [self setObject:anObject forKey:aKey autoRemove:NO];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey autoRemove: (BOOL)state
{
    id boxObj = boxAsWeakReference(anObject);
    
    if (state)
    {
        CopyAsWeak(self, ws);
        [anObject addDeallocBlock:^{
            [ws removeObjectForKey:aKey];
        }];
    }
    
    [_buffer setObject:boxObj forKey:aKey];
}

- (id)objectForKey:(id)aKey
{
    id obj = [_buffer objectForKey:aKey];
    return unboxWeakReference(obj);
}

- (id)objectForKeyedSubscript:(id)key
{
    id obj = [_buffer objectForKeyedSubscript:key];
    return unboxWeakReference(obj);
}

- (void)removeAllObjects
{
    [_buffer removeAllObjects];
}

- (void)removeObjectForKey:(id)aKey
{
    [_buffer removeObjectForKey:aKey];
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *temp = [_buffer mutableCopy];
    for (NSString *key in temp.allKeys)
    {
        id obj = temp[key];
        id eax = unboxWeakReference(obj);
        if (eax) temp[key] = eax;
        else [temp removeObjectForKey:key];
    }
    return temp;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len
{
    return [_buffer countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count
{
    return _buffer.count;
}

- (NSArray *)allKeys
{
    return _buffer.allKeys;
}

- (NSArray *)allValues
{
    return _buffer.allValues;
}

- (NSString *)description
{
    return [[self toDictionary] description];
}
@end
