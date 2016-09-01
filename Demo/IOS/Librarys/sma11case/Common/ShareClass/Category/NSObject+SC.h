//
//  NSObject+SC.h
//  sma11case
//
//  Created by sma11case on 15/8/23.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../typedef.h"

// Property Attribute Description Examples
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

@interface NSObject(sma11case_ShareClass)
+ (NSMutableDictionary *)visiablePropertiesListWithEndClass: (Class)cls; // {name:attrib}
- (NSMutableDictionary *)propertiesWithEndClass: (Class)cls; // {name:value}
- (void)changeClassTo: (Class)cls;
- (void)setAssociatedObject: (id)object key: (NSString *)key;
- (void)setWeakAssociatedObject: (id)object key: (NSString *)key;
- (id)getAssociatedObjectWithKey: (NSString *)key;
- (id)getWeakAssociatedObjectWithKey: (NSString *)key;
- (void)removeAssociatedObjectWithKey: (NSString *)key;
- (void)removeAssociatedObjects;
- (void *)addDeallocBlock: (EmptyBlock)block;
@end

