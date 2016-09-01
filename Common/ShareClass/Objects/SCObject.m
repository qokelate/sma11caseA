//
//  SCObject.m
//  sma11case
//
//  Created by sma11case on 15/8/19.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "SCObject.h"
#import "../Macros.h"
#import "../Functions.h"
#import <objc/runtime.h>
#import "CoreTools.h"
#import "../Category/Category.h"
#import "../IsRootClass.m"

#define SCLog(...) //MLog(__VA_ARGS__)

@interface SCObject ()

@end

@implementation SCObject

#if IS_DEBUG_MODE
ImpDebugDeallocMethod()
#endif

ImpIsRootClass(SCObject)

+ (instancetype)alloc
{
    id temp = [super alloc];
    SCLog(@"%p <%@:%@> alloc", temp, FType(NSObject *, self).class, FType(NSObject *, self).superclass);
    return temp;
}

- (instancetype)init
{
    SCLog(@"%p <%@:%@> init", self, FType(NSObject *, self).class, FType(NSObject *, self).superclass);
    return [super init];
}

- (NSDictionary *)properties
{
#if IS_SMA11CASE_VERSION
    return [self propertiesWithEndClass:SCObjectClass];
#else
    return [self propertiesWithEndClass:nil];
#endif
}

ImpDescriptionMethod()
@end
