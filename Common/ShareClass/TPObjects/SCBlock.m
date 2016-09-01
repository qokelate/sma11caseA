//
//  SCBlock.m
//  sma11case
//
//  Created by sma11case on 11/24/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCBlock.h"

@implementation SCBlock
{
    id _blockParam;
    NSObjectBlock _block;
    EmptyBlock _deallocBlock;
}

- (void)dealloc
{
    if (_deallocBlock) _deallocBlock();
}

+ (instancetype)blockWithDeallocBlock: (EmptyBlock)block
{
    return [[self alloc] initWithDeallocBlock:block];
}

- (instancetype)initWithDeallocBlock: (EmptyBlock)block
{
    self = [super init];
    if (self)
    {
        _deallocBlock = block;
    }
    return self;
}

//- (void)setSelectorWithParam: (id)object block: (NSObjectBlock)block
//{
//    _block = block;
//    _blockParam = object;
//}
//
//- (void)objectSelector: (id)param
//{
//    if (_block) _block(_blockParam);
//}
@end
