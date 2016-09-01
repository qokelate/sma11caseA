//
//  NSObject+SC.m
//  sma11case
//
//  Created by sma11case on 15/8/23.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+SC.h"
#import "../Macros.h"
#import "../Objects/DebugHelper.h"
#import "../Functions.h"
#import "../IsRootClass.m"
#import "../ExternalsSource/ExternalsSource.h"
#import "NSString+SC.h"
#import "../TPObjects/TPObjects.h"

MakeStaticChar(gs_userAssociated_atom);

#define SCLog(...) //MLog(__VA_ARGS__)

@implementation NSObject(sma11case_ShareClass)

+ (NSMutableDictionary *)visiablePropertiesListWithEndClass: (Class)cls
{
    return [self visiablePropertiesListWithEndClass:cls mustNil:nil];
}

+ (NSMutableDictionary *)visiablePropertiesListWithEndClass: (Class)cls mustNil: (id)mustNil
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (IsSameObject(self, NSObjectClass)) return nil;
    if (IsSameObject(self, SCObjectClass)) return nil;
    if (IsRootClass(self)) return nil;
#pragma clang diagnostic pop
    
    if (nil == mustNil) mustNil = NewMutableDictionary();
    NSMutableDictionary *result = FType(NSMutableDictionary *, mustNil);
    
    NSMutableDictionary *temp = getPropertyListWithClass(self);
    
    for (NSString *key in temp.allKeys)
    {
        NSString *attrib = temp[key];
        
        if (0 == key.length
            || NO == StringHasSubstring(attrib, @",V_")
            || [key hasPrefix:@"_"]
            )
        {
            continue;
        }
        
        result[key] = attrib;
    }
    
    if (cls && NO == IsSameObject(self, cls))
    {
        [[self superclass] visiablePropertiesListWithEndClass:cls mustNil:mustNil];
    }
    
    if (0 == result.count) return nil;
    return result;
}

- (NSMutableDictionary *)propertiesWithEndClass: (Class)cls
{
    NSDictionary *names = [SelfClass visiablePropertiesListWithEndClass:cls];
    
    if (0 == names.count) return nil;
    
    NSMutableDictionary *temp = NewMutableDictionary();
    
    for (NSString *key in names.allKeys)
    {
        id value = nil;
        NSString *attrib = names[key];
        if ([attrib hasPrefix:@"T^"])
        {
            void *ptr = NULL;
            NSString *temp = mergeString(@"_", key);
            BOOL state = getIvarValue(self, temp.UTF8String, sizeof(void *), &ptr);
            if (NO == state) ptr = (void *)-1UL;
            value = [NSValue valueWithPointer:ptr];
        }
        else value = [self valueForKey:key];
        SCLog(@"getValue: <%@: %@> = %@", key, [value class], value);
        
        if (value) [temp setObject:value forKey:key];
        else
        {
            if ([attrib hasPrefix:@"T@"]) [temp setObject:SCNil forKey:key];
            else [temp setObject:@(0) forKey:key];
        }
    }

    if (0 == temp.count) return nil;
    return temp;
}

- (void)changeClassTo: (Class)cls
{
    object_setClass(self, cls);
}

- (void)setAssociatedObject: (id)object key: (NSString *)key
{
    void *ptr = &gs_userAssociated_atom;
    NSMutableDictionary *associatedObjects = objc_getAssociatedObject(self, ptr);
    if (nil == associatedObjects)
    {
        associatedObjects = NewMutableDictionary();
        objc_setAssociatedObject(self, ptr, associatedObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    associatedObjects[key] = object;
}

- (void)setWeakAssociatedObject: (id)object key: (NSString *)key
{
    id obj = boxAsWeakReference(object);
    [self setAssociatedObject:obj key:key];
}

- (id)getAssociatedObjectWithKey: (NSString *)key
{
    void *ptr = &gs_userAssociated_atom;
    NSMutableDictionary *associatedObjects = objc_getAssociatedObject(self, ptr);
    if (nil == associatedObjects) return nil;
    
    return associatedObjects[key];
}

- (id)getWeakAssociatedObjectWithKey: (NSString *)key
{
    id obj = [self getAssociatedObjectWithKey:key];
    return unboxWeakReference(obj);
}

- (void)removeAssociatedObjectWithKey: (NSString *)key
{
    void *ptr = &gs_userAssociated_atom;
    NSMutableDictionary *associatedObjects = objc_getAssociatedObject(self, ptr);
    if (nil == associatedObjects) return ;
    
    [associatedObjects removeObjectForKey:key];
}


- (void)removeAssociatedObjects
{
    void *ptr = &gs_userAssociated_atom;
    objc_setAssociatedObject(self, ptr, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_removeAssociatedObjects(self);
}

- (void *)addDeallocBlock: (EmptyBlock)block
{
    SCBlock *temp = [SCBlock blockWithDeallocBlock:block];
    void *ptr = FBridge(temp, id, void*);
    objc_setAssociatedObject(self, ptr, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return ptr;
}
@end

