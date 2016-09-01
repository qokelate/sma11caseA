//
//  WeakArray.m
//  sma11case
//
//  Created by sma11case on 15/8/14.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "WeakArray.h"
#import "../Macros.h"
#import "../IsRootClass.m"
#import "../Category/Category.h"
#import "../Functions.h"

@interface WeakArray ()

@end

@implementation WeakArray
{
    NSMutableArray *_buffer;
}

+ (instancetype)arrayWithCapacity:(NSUInteger)numItems
{
    return [[self alloc] initWithCapacity:numItems];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _buffer = [NSMutableArray arrayWithCapacity:MinMutableCount];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    if (self = [super init])
    {
        _buffer = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (void)addObject:(id)anObject
{
    [self addObject:anObject autoRemove:NO];
}

- (void)addObject:(id)anObject autoRemove: (BOOL)state
{
    id boxObj = boxAsWeakReference(anObject);
    
    if (state)
    {
        CopyAsWeak(self, ws);
        CopyAsWeak(anObject, wb);
        [anObject addDeallocBlock:^{
            [ws removeObject:wb];
        }];
    }
    
    [_buffer addObject:boxObj];
}

- (id)objectAtIndex:(NSUInteger)index
{
    id anObject = [_buffer objectAtIndex:index];
    return unboxWeakReference(anObject);
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    id anObject = [_buffer objectAtIndex:idx];
    return unboxWeakReference(anObject);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    id boxObj = boxAsWeakReference(anObject);
    [_buffer insertObject:boxObj atIndex:index];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    id boxObj = boxAsWeakReference(obj);
    _buffer[idx] = boxObj;
}

- (void)removeAllObjects
{
    [_buffer removeAllObjects];
}

- (void)removeObject:(id)anObject
{
    NSUInteger count = self.count;
    for (NSUInteger a = 0; a < count; ++a)
    {
        id obj = [self objectAtIndex:a];
        if (obj == anObject)
        {
            [_buffer removeObjectAtIndex:a];
            break;
        }
    }
}

- (NSUInteger)count
{
    return _buffer.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len
{
    return [_buffer countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSMutableArray *)toArray
{
    NSMutableArray *temp = NewMutableArray();
    
    for (id obj in _buffer)
    {
        id eax = unboxWeakReference(obj);
        if (eax) [temp addObject:eax];
    }
    
    return temp;
}

- (NSString *)description
{
    return [[self toArray] description];
}
@end

