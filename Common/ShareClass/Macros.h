//
//  Macros.h
//  sma11case
//
//  Created by sma11case on 15/8/11.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "Config.h"
#import "typedef.h"
#import "SCConstants.h"

// 便捷宏
#define NotExecute if (0)
#define FBridge(x, y, z) ((__bridge z)(y)x)
#define ObjectToPtr_Retain(x) ((__bridge_retained void*)x)
#define PtrToObject_Release(x) ((__bridge_transfer id)(void *)x)
#define MakeStaticChar(x) static char x = 0

// 编译宏
#define SC_UNAVAILABLE __attribute__((unavailable))
#if IS_DEV_MODE
#define SC_DISABLED
#else
#define SC_DISABLED SC_UNAVAILABLE
#endif

// 调试宏
#if IS_DEBUG_MODE
#define MLog(...) NSLog(__VA_ARGS__)
#define CLog(...) printf(__VA_ARGS__)
#define AssertLog(x, ...) do{ if (x) MLog(__VA_ARGS__) }while(NO)
#define BreakPointHere MinSleep()
#else
#define MLog(...)
#define CLog(...)
#define BreakPointHere
#endif

#if USE_NSLOGGER
#import "ExternalsSource/NSLogger/LoggerClient.h"
#define KLog(x, ...) do { LogMessage(nil, x, __VA_ARGS__); NSLog(__VA_ARGS__); }while (NO)
#undef  MLog
#define MLog(...)    KLog(0, __VA_ARGS__)
#define LogImage(x)  LogImageData(@”image”, 0, 320, 240, UIImagePNGRepresentation(x))
#else
#define LogImage(x)
#define KLog(x, ...) MLog(__VA_ARGS__)
#endif

// 类型转换宏
#define StringToURL(x) [NSURL URLWithString:x]
#define NumberString(x) [NSString stringWithFormat:@"%@", @(x)]
#define PointerToObject(type, name, ptr) type name = (__bridge type)ptr

// 线程宏
#define GCDBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define GCDDefaultQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDHighQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define GCDMainQueue dispatch_get_main_queue()

// 简写宏
#define IsMainThread() [NSThread isMainThread]
#define CopyAsWeak(x, y) __weak typeof(&*x) y = x
#define CopyAsAssign(x, y) __unsafe_unretained typeof(x) y = x

#define IsHasSelector(x) [x respondsToSelector:selector]
#define IsSubclassOfClass(x, y) [x isSubclassOfClass: [y class]]
#define IsKindOfClass(x, y) [x isKindOfClass:[y class]]
#define IsMemberOfClass(x, y) [x isMemberOfClass:[y class]]
#define StringHasSubstring(x, y) ([x rangeOfString:y].length)

//#define CallSelector(...) performSelector1(__VA_ARGS__)
//#define CallSelectorWithNil(...) performSelector1(__VA_ARGS__, nil)
//#define CallSelectorX(x, ...) (x ? CallSelectorWithNil(__VA_ARGS__) : CallSelector(__VA_ARGS__))

#define NewClass(x) [[x alloc] init]
#define NewMutableString() [NSMutableString stringWithCapacity:StringBufferLength]
#define NewMutableSet() [[NSMutableSet alloc] initWithCapacity:MinMutableCount]
#define NewMutableArray() [NSMutableArray arrayWithCapacity:MinMutableCount]
#define NewMutableDictionary() [NSMutableDictionary dictionaryWithCapacity:MinMutableCount]
#define NewWeakArray() [WeakArray arrayWithCapacity:MinMutableCount]
#define NewWeakDictionary() [WeakDictionary dictionaryWithCapacity:MinMutableCount]

#define MinSleep() [NSThread sleepForTimeInterval:0.01]
#define WaitForObject(x) while (nil == x) MinSleep()

#define StringFormat(x, ...) [NSString stringWithFormat:x, __VA_ARGS__]
#define ObjectString(x) [NSString stringWithFormat:@"%@", x]
#define SafeString(x) (x.length ? x : @"")
#define IntegerValue(x) FType(NSString *, x).integerValue
#define BoolValue(x) FType(NSString *, x).boolValue

// 数据库
#define SQLExecuteUpdate(x, y) [x executeUpdateWithSQL:y params:nil block:nil]

// 实例宏
#define SelfClass [self class]
#define NSObjectClass [NSObject class]

#define NSNC [NSNotificationCenter defaultCenter]

#define NSUD [NSUserDefaults standardUserDefaults]
#define NSUDWriteObject(x, y) do{ [NSUD setObject:y  forKey:x]; [NSUD synchronize]; } while (false)
#define NSUDWriteBool(x, y)   do{ [NSUD setBool:y    forKey:x]; [NSUD synchronize]; } while (false)
#define NSUDWriteNumber(x, y) do{ [NSUD setInteger:y forKey:x]; [NSUD synchronize]; } while (false)

// 日志宏
#define LogFunctionNameAndParent() do{ LogFunctionName(); LogWhoCallMe(); }while (false)
#define LogCurrentThread() LogObject([NSThread currentThread])

// 工具宏
#define IsTypeOf(type, var) (0 == strcmp(@encode(type), @encode(typeof(var))))
#define ToString(x) FType(NSObject *, Object(x)).description
#define IsNSNull(x) (IsSameObject(x, [NSNull null]) || IsKindOfClass(x, NSNull))
#define FType(x, y) ((x)y)
#define IsFTSame(type, x, y) (FType(type, x) == FType(type, y))
#define IsSameObject(x, y) IsFTSame(id, x, y)
#define IsSameString(x, y) (IsSameObject(x, y) || [x isEqualToString:y])
#define IsInstance(x, y) IsSameObject([x class], [y class])
#define IsSameCString(x, y) ((x) == (y) || 0 == strcmp((x), (y)))

// 类创建
#define StringToURL(x) [NSURL URLWithString:x]

// 类工具宏
#define SET_INT_PROPERTY(a, x)    _##x = (a[@""#x""] ? ((NSNumber *)a[@""#x""]).integerValue : _##x)
#define SET_BOOL_PROPERTY(a, x)   _##x = (a[@""#x""] ? ((NSNumber *)a[@""#x""]).boolValue : _##x)
#define SET_STRING_PROPERTY(a, x) _##x = (a[@""#x""] ? ObjectString(a[@""#x""]) : (_##x ? _##x : @""))
#define SET_DOUBLE_PROPERTY(a, x) _##x = ((NSString *)a[@""#x""]).doubleValue
#define SET_TIME_PROPERTY(a, x) _##x = (NSTimeInterval)((NSString *)a[@""#x""]).doubleValue
#define PACK_PROPERTY(a, x) (_##x ? [a setObject:Object(_##x) forKey:@""#x""] : [a setObject:@"" forKey:@""#x""])

// 实现宏
#define DefSharedMethod() + (instancetype)shared
#define ImpSharedMethod() + (instancetype)shared\
{\
static id singleton = nil;\
if (nil == singleton)\
{\
static dispatch_once_t onceToken = 0;\
dispatch_once(&onceToken, ^{\
singleton = [[self alloc] init];\
});\
}\
while (nil == singleton) MinSleep();\
return singleton;\
}

#define ImpDebugDeallocMethod() - (void)dealloc\
{\
    MLog(@"%p <%@:%@> dealloc", self, [self class], self.superclass);\
}

#define ImpDebugAllocMethod() + (instancetype)alloc\
{\
    id temp = [super alloc];\
    MLog(@"%p <%@:%@> alloc", temp, [FType(NSObject *, temp) class], FType(NSObject *, temp).superclass);\
    return temp;\
}

#define ImpInitMethod() - (instancetype)init\
{\
    self = [super init];\
    return self;\
}

#define ImpDescriptionMethod() - (NSString *)description\
{\
    NSDictionary *temp = [self propertiesWithEndClass:NSObjectClass];\
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, (temp.count ? temp : @"")];\
}

