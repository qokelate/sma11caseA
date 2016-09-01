//
//  WeakArray.h
//  sma11case
//
//  Created by sma11case on 15/8/14.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"
#import "../SCProtocal.h"

#if (IS_DEV_MODE && IS_DEBUG_MODE)
#define SCArray NSMutableArray
#else
#define SCArray NSObject
#endif

@interface WeakArray : SCArray<SCArrayEnumeration>
@property (nonatomic, assign, readonly) NSUInteger count;

+ (instancetype)arrayWithCapacity:(NSUInteger)numItems;

- (instancetype)initWithCapacity:(NSUInteger)numItems;

- (void)addObject:(id)anObject;
- (void)addObject:(id)anObject autoRemove: (BOOL)state;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (id)objectAtIndex:(NSUInteger)index;

- (void)removeAllObjects;
- (void)removeObject:(id)anObject;

- (NSMutableArray *)toArray;
@end


