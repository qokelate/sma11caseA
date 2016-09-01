//
//  WeakSet.m
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "WeakSet.h"
#import "../Functions.h"
#import "WeakArray.h"
#import "../Category/Category.h"

#if UseExpeAPI
@implementation WeakSet
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
        [anObject addDeallocBlock:^{
            [ws removeObject:boxObj];
        }];
    }
    
    [super addObject:boxObj];
}

- (id)anyObject
{
    id anObject = [super anyObject];
    return unboxWeakReference(anObject);
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len
{
    NSUInteger res = [super countByEnumeratingWithState:state objects:buffer count:len];
    if (res)
    {
        NSUInteger count = 0;
        for (NSUInteger a = 0; a < res; ++a)
        {
            id obj = buffer[a];
            id eax = unboxWeakReference(obj);
            if (eax) buffer[count++] = eax;
        }
        
        res = count;
    }
    return res;
}
@end
#endif

