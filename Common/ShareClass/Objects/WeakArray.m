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
#import "../TPObjects/TPObjects.h"

#undef UseExpeAPI
#define UseExpeAPI 0UL

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
        CopyAsAssign(anObject, wb);
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

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    id boxObj = boxAsWeakReference(anObject);
    [_buffer insertObject:boxObj atIndex:index];
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

#pragma mark SCArrayEnumeration
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    id anObject = [_buffer objectAtIndex:idx];
    return unboxWeakReference(anObject);
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    id boxObj = boxAsWeakReference(obj);
    _buffer[idx] = boxObj;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    if(0 == state->state)
    {
        state->mutationsPtr = FBridge(self, id, void*);
        state->extra[0] = 0;
        state->state = 1;
    }
    
    unsigned long copied = state->extra[0];
    
    NSUInteger count = _buffer.count;
    if (count == copied) return 0;
    
    state->itemsPtr = buffer;
    NSUInteger result = 0;
    
    for (NSUInteger a = 0; a < len; ++a)
    {
        __unsafe_unretained id obj = unboxWeakReference(_buffer[copied++]);
        if (copied == count) break;
        if (nil == obj) continue;
        
        buffer[result++] = obj;
    }
    
    state->extra[0] = copied;
    
    return result;
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

