//
//  SCBlock.m
//  sma11case
//
//  Created by sma11case on 11/24/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCBlock.h"
#import "../Macros.h"
#import <objc/runtime.h>

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
@end

@implementation NSObject(sma11case_Extend)
- (void *)addDeallocBlock: (EmptyBlock)block
{
    SCBlock *temp = [SCBlock blockWithDeallocBlock:block];
    void *ptr = FBridge(temp, id, void*);
    objc_setAssociatedObject(self, ptr, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return ptr;
}
@end
