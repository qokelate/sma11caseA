//
//  WeakSet.h
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#if UseExpeAPI
@interface WeakSet : NSMutableSet
- (void)addObject:(id)anObject autoRemove: (BOOL)state;
@end
#endif
