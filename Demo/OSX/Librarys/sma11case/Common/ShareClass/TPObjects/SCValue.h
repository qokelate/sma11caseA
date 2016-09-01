//
//  SCValue.h
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRoot.h"

@interface SCPointer : SCRoot
@property (nonatomic, assign) void *address;

+ (instancetype)pointerWithAddress: (void *)address;
- (NSValue *)toValue;
@end

@interface SCSelector : SCRoot
@property (nonatomic, assign) SEL selector;

+ (instancetype)selectorWithSelector: (SEL)selector;
@end
