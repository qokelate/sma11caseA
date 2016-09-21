//
//  SCBlock.h
//  sma11case
//
//  Created by sma11case on 11/24/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRoot.h"
#import "../typedef.h"

@interface NSObject(sma11case_Extend)
- (void *)addDeallocBlock: (EmptyBlock)block;
@end

@interface SCBlock : SCRoot
+ (instancetype)blockWithDeallocBlock: (EmptyBlock)block;
- (instancetype)initWithDeallocBlock: (EmptyBlock)block;
@end

