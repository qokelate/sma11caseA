//
//  WeakDictionary.h
//  sma11case
//
//  Created by sma11case on 15/8/19.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"
#import "../SCProtocal.h"

#if (IS_DEV_MODE && IS_DEBUG_MODE)
#define SCDictionary NSMutableDictionary
#else
#define SCDictionary NSObject
#endif

@interface WeakDictionary : SCDictionary<SCDictionaryEnumeration>
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, strong, readonly) NSArray *allKeys;
@property (nonatomic, strong, readonly) NSArray *allValues;

+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems;

- (instancetype)initWithCapacity:(NSUInteger)numItems;

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey autoRemove: (BOOL)state;

- (id)objectForKey:(id)aKey;

- (void)removeAllObjects;
- (void)removeObjectForKey:(id)aKey;

- (NSMutableDictionary *)toDictionary;
@end
