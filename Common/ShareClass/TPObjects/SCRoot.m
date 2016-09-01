//
//  SCRoot.m
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCRoot.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
#import "../Functions.h"
#import "../IsRootClass.m"

#if __has_feature(objc_arc)
#error "This file must be compiled without ARC."
#endif

#undef LogFunctionName
#define LogFunctionName()

@implementation SCRoot
{
    Class isa;
    volatile int32_t retainCount;
}

ImpIsRootClass(SCRoot)

- (Class)superclass
{
    LogFunctionName();
    return [[self class] superclass];
}

- (Class)class
{
    LogFunctionName();
    return isa;
}

- (id)self
{
    LogFunctionName();
    return self;
}

- (id)retain
{
    LogFunctionName();
    OSAtomicIncrement32(&retainCount);
    return self;
}

- (oneway void)release
{
    LogFunctionName();
    uint32_t newCount = OSAtomicDecrement32(&retainCount);
    if(newCount == 0) [self dealloc];
}

- (id)autorelease
{
    LogFunctionName();
    [NSAutoreleasePool addObject: self];
    return self;
}

- (NSUInteger)retainCount
{
    LogFunctionName();
    return retainCount;
}

- (NSString *)description
{
    LogFunctionName();
    return [NSString stringWithFormat: @"<%@: %p>", NSStringFromClass([self class]), self];
}

+ (void)load
{
    LogFunctionName();
}

+ (void)initialize
{
    LogFunctionName();
}

- (id)init
{
    LogFunctionName();
    
    return self;
}

+ (id)new
{
    LogFunctionName();
    return [[self alloc] init];
}

+ (id)alloc
{
    LogFunctionName();
    
    SCRoot *obj = calloc(1, class_getInstanceSize(self));
    obj->isa = self;
    obj->retainCount = 1;
    return obj;
}

- (void)dealloc
{
    MLog(@"%p <%@:%@> dealloc", self, [self class], self.superclass);
    free(self);
}

- (void)finalize
{
    LogFunctionName();
}

- (BOOL)isKindOfClass: (Class)aClass
{
    return [isa isSubclassOfClass: aClass];
}

- (BOOL)isMemberOfClass: (Class)aClass
{
    return isa == aClass;
}

+ (Class)superclass
{
    LogFunctionName();
    return class_getSuperclass(self);
}

+ (Class)class
{
    LogFunctionName();
    return self;
}

+ (NSString *)description
{
    LogFunctionName();
    return [NSString stringWithUTF8String: class_getName(self)];
}

+ (BOOL)isSubclassOfClass: (Class)aClass
{
    LogFunctionName();
    for(Class candidate = self; candidate != nil; candidate = [candidate superclass])
        if (candidate == aClass)
            return YES;
    
    return NO;
}

- (void)doesNotRecognizeSelector: (SEL)aSelector
{
    LogFunctionName();
    LogAnything(aSelector);
    MLog(@"class '%@' does not implement @selector(%@)", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
}

- (BOOL)respondsToSelector: (SEL)aSelector
{
    LogFunctionName();
    return NO;
//    return class_respondsToSelector(isa, aSelector);
}
@end
