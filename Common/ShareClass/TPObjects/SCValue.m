//
//  SCValue.m
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCValue.h"

@implementation SCPointer
+ (instancetype)pointerWithAddress: (void *)address
{
    SCPointer *p = [[self alloc] init];
    p.address = address;
    return p;
}

- (NSValue *)toValue
{
    return [NSValue valueWithPointer:_address];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Pointer: %p", _address];
}
@end

@implementation SCSelector
+ (instancetype)selectorWithSelector:(SEL)selector
{
    SCSelector *p = [[self alloc] init];
    p.selector = selector;
    return p;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"SEL: %@", NSStringFromSelector(_selector)];
}
@end
