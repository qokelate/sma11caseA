//
//  SCFakeObject.h
//  sma11case
//
//  Created by sma11case on 12/17/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRoot.h"

typedef void(^SCFakeBlock)(id<NSObject> target);
typedef void(^EnumIvarsBlock)(NSString *ivarName, id value);

@class NSKeyValueProperty;

@interface SCFakeObject : SCRoot
@property (nonatomic, strong) id target;

+ (void)enumIvarsWithObject: (id)object block: (EnumIvarsBlock)block;
+ (void)fakeObjectWithTarget: (id)target block: (SCFakeBlock)block;
+ (instancetype)fakeObjectWithTarget: (id)target;
- (instancetype)initWithTarget: (id)target;
@end

@protocol SCFakeObject_NSKeyValueObservationInfo <NSObject>
@required
- (NSArray *)observances;
- (NSHashTable *)observables;
- (NSUInteger)cachedHash;
- (BOOL)cachedIsShareable;
@end

@protocol SCFakeObject_NSKeyValueObservance <NSObject>
- (NSArray *)observationInfos;
- (NSObject *)originalObservable;
- (NSUInteger)options;
- (int)retainCountMinusOne;
- (NSKeyValueProperty *)property;
- (NSUInteger)cachedUnrotatedHashComponent;
- (NSObject *)observer;
- (void *)context;
- (BOOL)cachedIsShareable;
@end

@protocol SCFakeObject_NSKeyValueUnnestedProperty <NSObject>
- (NSArray *)affectingProperties;
- (BOOL)cachedIsaForAutonotifyingIsValid;
- (Class)cachedIsaForAutonotifying;
@end

@protocol SCFakeObject_NSWeakCallback <NSObject>
- (id)callback_target;
- (void *)callback_function;
- (id)callback_next;
@end


