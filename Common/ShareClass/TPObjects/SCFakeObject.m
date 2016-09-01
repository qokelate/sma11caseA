//
//  SCFakeObject.m
//  sma11case
//
//  Created by sma11case on 12/17/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "SCFakeObject.h"
#import "../Functions.h"
#import "SCValue.h"
#import "../CrossPlatform/CrossPlatform.h"
#import <objc/runtime.h>

#define SCLog(...) //MLog(__VA_ARGS__)

// 返回值类型, 方法名称, 实例名称
#define ImpFakeMethod(x, y, z) - (x)y\
{\
x result = (x)(0);\
getIvarValue(_target, z, sizeof(x), &result);\
return result;\
}

#define ImpFakeMethodWithBOOL(x)       ImpFakeMethod(BOOL, x, "_" #x)

#define ImpFakeMethodWithId(x)         ImpFakeMethod(id, x, "_" #x)

#define ImpFakeMethodWithClass(x)      ImpFakeMethod(Class, x, "_" #x)

#define ImpFakeMethodWithPointer(x)    ImpFakeMethod(void *, x, "_" #x)

#define ImpFakeMethodWithNSUInteger(x) ImpFakeMethod(NSUInteger, x, "_" #x)

#define ImpFakeMethodWithInt(x)        ImpFakeMethod(int, x, "_" #x)

@implementation SCFakeObject
+ (void)fakeObjectWithTarget: (id)target block: (SCFakeBlock)block
{
    SCLog(@"fakeObjectTarget: %p <%@:%@>", target, [target class], [target superclass]);
    id<NSObject> temp = [self fakeObjectWithTarget:target];
    block(temp);
}

+ (instancetype)fakeObjectWithTarget: (id)target
{
    return [[self alloc] initWithTarget:target];
}

- (instancetype)initWithTarget: (id)target
{
    if (self = [super init])
    {
        _target = target;
    }
    return self;
}

+ (void)enumIvarsWithObject: (id)object block: (EnumIvarsBlock)block
{
    NSDictionary *temp = getIvarListWithClass([object class]);
    
    const char *type = NULL;
 
    SCLog(@"CLASS: %@ SuperClass: %@, ivars: %@", [object class], [object superclass], temp);
    for (NSString *key in temp.allKeys)
    {
        NSString *value = temp[key];
        type = value.UTF8String;
        
        size_t size = 0UL;
        void **p = NULL;
        {
            Ivar thisIvar = class_getInstanceVariable([object class], key.UTF8String);
            ptrdiff_t offset = ivar_getOffset( thisIvar );
            if (0 == offset)
            {
                block(key, nil);
            }
            
            p = ((__bridge void *)object) + offset;
        }
        
        id output = packToObjectEx(&size, type, *p);
        block(key, output);
    }
}
@end

@implementation SCFakeObject(SCFakeObject_NSKeyValueObservationInfo)
ImpFakeMethodWithId(observances)
ImpFakeMethodWithId(observables)
ImpFakeMethodWithNSUInteger(cachedHash)
ImpFakeMethodWithBOOL(cachedIsShareable)
//@end

//@implementation SCFakeObject(SCFakeObject_NSKeyValueObservance)
ImpFakeMethodWithId(observationInfos)
ImpFakeMethodWithId(originalObservable)
ImpFakeMethodWithNSUInteger(options)
ImpFakeMethodWithInt(retainCountMinusOne)
ImpFakeMethodWithId(property)
ImpFakeMethodWithNSUInteger(cachedUnrotatedHashComponent)
ImpFakeMethodWithId(observer)
ImpFakeMethodWithPointer(context)
//ImpFakeMethodWithBOOL(cachedIsShareable)
//@end

//@implementation SCFakeObject(SCFakeObject_NSKeyValueUnnestedProperty)
ImpFakeMethodWithId(affectingProperties)
ImpFakeMethodWithBOOL(cachedIsaForAutonotifyingIsValid)
ImpFakeMethodWithClass(cachedIsaForAutonotifying)
//@end

//@implementation SCFakeObject(SCFakeObject_NSWeakCallback)
ImpFakeMethodWithId(callback_target)
ImpFakeMethodWithPointer(callback_function)
ImpFakeMethodWithId(callback_next)
@end

