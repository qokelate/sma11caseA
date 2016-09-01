//
//  NSNotificationCenter+SC.m
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import "NSNotificationCenter+SC.h"
#import "NSObject+SC.h"
#import "../Macros.h"

@implementation NSNotificationCenter(sma11case_shareClass)
- (void)addObserverSafe:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [self addObserver:observer selector:aSelector name:aName object:anObject];
    
    CopyAsWeak(observer, ws);
    [observer addDeallocBlock:^{
        [ws removeObserver:ws];
    }];
}
@end
