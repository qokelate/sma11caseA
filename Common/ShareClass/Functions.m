//
//  Functions.m
//  sma11case
//
//  Created by sma11case on 15/8/14.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "Functions.h"
#import "Views/ViewsConfig.h"
#import <objc/message.h>
#import "Objects/SCObject.h"
#import "IsRootClass.m"
#import "Category/Category.h"
#import "TPObjects/SCValue.h"
#import <dlfcn.h>

#define SCLog(...) //NSLog(__VA_ARGS__)

#if PLAT_IOS
#define valueWithCPPoint valueWithCGPoint
#define valueWithCPSize  valueWithCGSize
#define valueWithCPRect  valueWithCGRect
#define valueWithCPEdgeInsets valueWithUIEdgeInsets
#endif

#if PLAT_OSX
#import <Foundation/NSGeometry.h>

#define valueWithCPPoint valueWithPoint
#define valueWithCPSize  valueWithSize
#define valueWithCPRect  valueWithRect
#define valueWithCPEdgeInsets valueWithEdgeInsets
#endif

pfSendMessage0 sc_SendMessage0 = (pfSendMessage0)objc_msgSend;
pfSendMessage1 sc_SendMessage1 = (pfSendMessage1)objc_msgSend;

id getSCNil()
{
    static id scnil = nil;
    if (nil == scnil) scnil = [NSNull null];
    return scnil;
}

NSString *getCommonRootPath(NSString *path1, NSString *path2)
{
    NSArray *name1 = [path1 pathComponents];
    if (0 == name1.count) return nil;
    
    NSArray *name2 = [path2 pathComponents];
    if (0 == name2.count) return nil;
    
    NSMutableString *result = nil;
    
    NSUInteger a = MIN(name1.count, name2.count);
    for (NSUInteger b = 0; b < a; ++b)
    {
        NSString *s1 = name1[b];
        NSString *s2 = name2[b];
        
        if ([@"/" isEqualToString:s1]) continue;
        if (IsSameString(s1, s2))
        {
            if (nil == result) result = NewMutableString();
            [result appendFormat:@"/%@", s1];
        }
    }
    
    return result;
}

size_t getFileSize(const char *file)
{
    FILE *handle = fopen(file, "rb");
    if (handle)
    {
        fseek(handle, 0L, SEEK_END);
        size_t size = ftell(handle);
        fclose(handle);
        return size;
    }
    
    return 0;
}

NSStringEncoding getFileEncodingFromBOM(const char *file)
{
    size_t size = getFileSize(file);
    
    NSStringEncoding enc = NSASCIIStringEncoding;
     if (0 == size) return enc;
    
    FILE *handle = fopen(file, "rb");
    
    if (2 == size)
    {
        unsigned char buffer[2] = {0};
        fread(buffer, 2, sizeof(char), handle);
        
        if (0xFF == buffer[0] && 0xFE == buffer[1]) enc = NSUnicodeStringEncoding;
    }
    
    else if (size >= 3)
    {
        unsigned char buffer[3] = {0};
        fread(buffer, 3, sizeof(char), handle);
        
        if (0xEF == buffer[0] && 0xBB == buffer[1] && 0xBF == buffer[2]) enc = NSUTF8StringEncoding;
    }
    
    fclose(handle);
    
    return enc;
}

void enterRunLoop(NSString *runMode)
{
    BOOL isRunning = NO;
    do
    {
        isRunning = [[NSRunLoop currentRunLoop] runMode:runMode beforeDate:[NSDate distantFuture]];
    } while (isRunning);
}

void *getMethodAddress(id object, SEL selector)
{
    // __builtin_return_address(0)
    IMP imp = [object methodForSelector:selector];
    pfSendMessage1 p = FType(pfSendMessage1, imp);
    return p;
}

unsigned long hexStringToUnsignedLongValue(const char *string)
{
    unsigned long result = 0;
    size_t n = 0;
    
    size_t len = strlen(string);
    
    if (len > 1 && '#' == string[0])
    {
        string += 1;
        len -= 1;
    }
    else if (len > 2 && 'x' == string[1] && '0' == string[0])
    {
        string += 2;
        len -= 2;
    }
    
    if (len > (2*sizeof(long))) len = 2 * sizeof(long);
    
    for(size_t i = 0; i < len; ++i)
    {
        char c = *(string + i);
        
        if ('0' <= c && c <= '9') n = c - '0';
        else if ('a' <= c && c <= 'f') n = c - 'a' + 0xA;
        else if ('A' <= c && c <= 'F') n = c - 'A' + 0xA;
        else return 0;
        
        n <<= ((len-i-1)<<2);
        result |= n;
    }
    
    return result;
}

inline WeakReference boxAsWeakReference(id object)
{
    __weak id weakref = object;
    return ^{ return weakref; };
}

inline id unboxWeakReference(WeakReference ref)
{
    return (nil == ref ? nil : ref());
}

NSMutableArray *getMethodListWithClass(Class cls)
{
    unsigned int count = 0;
    Method *methods= class_copyMethodList(cls, &count);
    
    if (0 == count)
    {
        if (methods) free(methods);
        return nil;
    }
    
    NSMutableArray *temp = NewMutableArray();
    for (unsigned long i = 0; i < count ; ++i)
    {
        SEL name = method_getName(methods[i]);
        NSString *str = NSStringFromSelector(name);
        [temp addObject:str];
    }
    
    free(methods);
    return temp;
}

NSMutableDictionary *getPropertyListWithClass(Class cls)
{
    NSMutableDictionary *temp = NewMutableDictionary();
    
    unsigned int count = 0;
    objc_property_t *props = class_copyPropertyList(cls, &count);//获得属性列表
    
    for(int i = 0; i < count; ++i)
    {
        objc_property_t prop = props[i];
        
        const char *name = property_getName(prop);
        if (0 == name[0]) continue; // <no name>
        
        const char *attrib = property_getAttributes(prop);
        
        NSString *propName = [NSString stringWithUTF8String:name];
        NSString *propAttrib = [NSString stringWithUTF8String:attrib];
        SCLog(@"<%@> = %s", propName, attrib);
        
        [temp setObject:propAttrib forKey:propName];
    }
    
    if (props) free(props);
    
    if (0 == temp.count) return nil;
    return temp;
}

NSMutableDictionary *getIvarListWithClass(Class cls)
{
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList(cls, &numIvars);
    
    if (0 == numIvars)
    {
        if (ivars) free(ivars);
        return nil;
    }
    
    NSMutableDictionary *result = NewMutableDictionary();
    
    for(NSUInteger i = 0; i < numIvars; ++i)
    {
        Ivar thisIvar = ivars[i];
        NSString *temp = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        
        result[temp] = stringType;
    }
    
    free(ivars);
    return result;
}

BOOL getIvarValue(id instance, const char *name, size_t size, void *buffer)
{
    Ivar thisIvar = class_getInstanceVariable([instance class], name);
    ptrdiff_t offset = ivar_getOffset( thisIvar );
    if (0 == offset) return NO;
    
    void *ptr = FBridge(instance, id, void*) + offset;
    memset(buffer, 0, size);
    memcpy(buffer, ptr, size);
    return YES;
}

#undef mergeString
NSString *mergeString(NSString *first, ...)
{
    NSUInteger count = 0;
    
    {
        va_list ap;
        va_start(ap, first);
        
        NSString *begin = first;
        
        while (begin)
        {
            count += begin.length;
            begin = va_arg(ap, NSString *);
        }
        
        va_end(ap);
        
        if (0 == count) return nil;
    }
    
    NSMutableString *temp = [NSMutableString stringWithCapacity:count];
    
    {
        va_list ap;
        va_start(ap, first);
        
        while (first)
        {
            [temp appendString:first];
            first = va_arg(ap, NSString *);
        }
        
        va_end(ap);
    }
    
    return temp;
}

#undef mergeArray
NSMutableArray *mergeArray(NSArray *first, ...)
{
    if (nil == first) return nil;
    
    va_list ap;
    va_start(ap, first);
    
    NSMutableArray *temp = [first mutableCopy];
    
    first = va_arg(ap, NSArray *);
    while (first)
    {
        for (id obj in first)
        {
            [temp addObject:obj];
        }
        first = va_arg(ap, NSArray *);
    }
    
    va_end(ap);
    return temp;
}

#undef mergeArrayIntoArray
void mergeArrayIntoArray(NSMutableArray *output, NSArray *first, ...)
{
    va_list ap;
    va_start(ap, first);
    
    while (first)
    {
        for (id obj in first)
        {
            [output addObject:obj];
        }
        first = va_arg(ap, NSArray *);
    }
    
    va_end(ap);
}

#undef mergeDictionary
NSMutableDictionary *mergeDictionary(NSDictionary *first, ...)
{
    if (nil == first) return nil;
    
    va_list ap;
    va_start(ap, first);
    
    NSMutableDictionary *temp = [first mutableCopy];
    
    first = va_arg(ap, NSDictionary *);
    while (first)
    {
        for (NSString *key in first.allKeys)
        {
            id obj = first[key];
            [temp setObject:obj forKey:key];
        }
        first = va_arg(ap, NSDictionary *);
    }
    
    va_end(ap);
    return temp;
}

#undef mergeDictionaryIntoDictonary
void mergeDictionaryIntoDictonary(NSMutableDictionary *output, NSDictionary *first, ...)
{
    va_list ap;
    va_start(ap, first);
    
    while (first)
    {
        for (NSString *key in first.allKeys)
        {
            id obj = first[key];
            [output setObject:obj forKey:key];
        }
        first = va_arg(ap, NSDictionary *);
    }
    
    va_end(ap);
}

inline void runBlockWithMain(dispatch_block_t block)
{
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

inline void runBlockWithAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

#undef runBlockWithGroup
inline void runBlockWithGroup(dispatch_queue_t queue, dispatch_block_t finishedBlock, dispatch_block_t block, ...)
{
    va_list ap;
    va_start(ap, block);
    
    dispatch_group_t group = dispatch_group_create();
    
    while (block)
    {
        dispatch_group_async(group, queue, block);
        block = va_arg(ap, dispatch_block_t);
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    if (finishedBlock) dispatch_async(queue, finishedBlock);
}

#undef runBlockWithMainEx
void runBlockWithMainEx(dispatch_block_t block, ...)
{
    va_list ap;
    va_start(ap, block);
    
    BOOL state = [NSThread isMainThread];
    while (block)
    {
        if (state) block();
        else dispatch_async(dispatch_get_main_queue(), block);
        block = va_arg(ap, dispatch_block_t);
    }
}

#undef runBlockWithAsyncEx
void runBlockWithAsyncEx(dispatch_block_t block, ...)
{
    va_list ap;
    va_start(ap, block);
    while (block)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
        block = va_arg(ap, dispatch_block_t);
    }
}

void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asyncBlock();
        dispatch_async(dispatch_get_main_queue(), syncBlock);
    });
}

void syncBlockWithMain(dispatch_block_t block)
{
    if (NO == [NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), block);
        return;
    }
    
    block();
}

id packToObject(const char *type, ...)
{
    va_list v;
    va_start(v, type);
    unsigned long start = va_arg(v, unsigned long);
    va_end(v);
    return packToObjectEx(NULL, type, start);
}

id packToObjectEx(size_t *size, const char *type, ...)
{
//    MLog(@"decode <%s>", type);
    
    va_list v;
    va_start(v, type);
    id obj = nil;
    
    size_t types = 0UL;
    char *type1;
    char type2[64];
    
    size_t nSize = 0;
    if (NULL == size) size = &nSize;
    
    if (strcmp(type, @encode(id)) == 0
        || strcmp(type, @encode(typeof(^{}))) == 0
        || strcmp(type, @encode(Class)) == 0)
    {
        *size = sizeof(id);
        id actual = va_arg(v, id);
        obj = actual;
        return obj;
    }

    if (strcmp(type, @encode(SEL)) == 0)
    {
        *size = sizeof(SEL);
        SEL actual = (SEL)va_arg(v, SEL);
        obj = [SCSelector selectorWithSelector:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(double)) == 0)
    {
        *size = sizeof(double);
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(float)) == 0)
    {
        *size = sizeof(float);
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(int)) == 0)
    {
        *size = sizeof(int);
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(long)) == 0)
    {
        *size = sizeof(long);
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(long long)) == 0)
    {
        *size = sizeof(long long);
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(short)) == 0)
    {
        *size = sizeof(short);
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(char)) == 0)
    {
        *size = sizeof(char);
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(bool)) == 0)
    {
        *size = sizeof(bool);
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(unsigned char)) == 0)
    {
        *size = sizeof(unsigned char);
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(unsigned int)) == 0)
    {
        *size = sizeof(unsigned int);
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(unsigned long)) == 0)
    {
        *size = sizeof(unsigned long);
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(unsigned long long)) == 0)
    {
        *size = sizeof(unsigned long long);
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(unsigned short)) == 0)
    {
        *size = sizeof(unsigned short);
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
        return obj;
    }
    
    if (strcmp(type, @encode(const char *)) == 0)
    {
        *size = sizeof(const char *);
        char *actual = (char *)va_arg(v, char *);
        obj = [NSString stringWithCString:actual encoding:NSUTF8StringEncoding];
        return obj;
    }

    // 结构类型需要特殊处理
    // 例如@encode(CGRect) = {CGRect={CGPoint=dd}{CGSize=dd}}
    type1 = "{CGPoint=";
    types = strlen(type1);
    memcpy(type2, type, types);
    type2[types] = 0UL;
    if (strcmp(type1, type2) == 0)
    {
        *size = sizeof(CGPoint);
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue valueWithCPPoint:actual];
        return obj;
    }
    
    type1 = "{CGSize=";
    types = strlen(type1);
    memcpy(type2, type, types);
    type2[types] = 0UL;
    if (strcmp(type1, type2) == 0)
    {
        *size = sizeof(CGSize);
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue valueWithCPSize:actual];
        return obj;
    }
    
    type1 = "{CGRect=";
    types = strlen(type1);
    memcpy(type2, type, types);
    type2[types] = 0UL;
    if (strcmp(type1, type2) == 0)
    {
        *size = sizeof(CGRect);
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = [NSValue valueWithCPRect:actual];
        return obj;
    }
    
    type1 = "{CPEdgeInsets=";
    types = strlen(type1);
    memcpy(type2, type, types);
    type2[types] = 0UL;
    if (strcmp("{UIEdgeInsets=", type2) == 0 || strcmp("{NSEdgeInsets=", type2) == 0)
    {
        *size = sizeof(CPEdgeInsets);
        CPEdgeInsets actual = (CPEdgeInsets)va_arg(v, CPEdgeInsets);
        obj = [NSValue valueWithCPEdgeInsets:actual];
        return obj;
    }

    // 处理其它特殊情况
    {
        char *actual = (char *)va_arg(v, char *);
        if ('[' == type[0] && actual)
        {
            size_t len = strlen(actual) + 1;
            char temp[len + 4];
            sprintf(temp, "[%luc]", len);
            if (0 == strcmp(type, temp))
            {
                *size = sizeof(char *);
                obj = [NSString stringWithCString:actual encoding:NSUTF8StringEncoding];
                return obj;
            }
        }
        va_start(v, type);
    }
    
    if ('^' == type[0]
        || '*' == type[strlen(type)-1]
        || strcmp(type, @encode(void *)) == 0)
    {
        *size = sizeof(void *);
        void *actual = (void *)va_arg(v, void *);
        obj = [SCPointer pointerWithAddress:actual];
        return obj;
    }

    
    va_end(v);
    
#if IS_DEBUG_MODE
    if (nil == obj)
    {
        *size = 0UL;
        void *actual = (void *)va_arg(v, void *);
        MLog(@"%p <%s> decode type error", actual, type);
    }
#endif
    
    return obj;
}

NSString *getCachesDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}


NSString *getDocumentDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

NSString *getTemporaryDirectory()
{
    NSString *tmpDir =  NSTemporaryDirectory();
    return tmpDir;
}

NSString *getHomeDirectory()
{
    NSString *homeDir = NSHomeDirectory();
    return homeDir;
}

NSString *getPinyin(NSString *string,BOOL isShort)
{
    if (0 == string.length) return @"";
    
    NSMutableString *source = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    if (isShort)
    {
        NSArray *shorts = [source componentsSeparatedByString:@" "];
        NSMutableString *shortPy = [NSMutableString string];
        for (NSString *s in shorts)
        {
            if (s.length > 0)
            {
                [shortPy appendString:[s substringToIndex:1]];
            }
        }
        
        return shortPy;
    }
    else
    {
        return source;
    }
}

#if UsePrivateAPI
NSArray *getInstalledAppBundleId()
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    return [workspace performSelector:@selector(allApplications)];
#pragma clang diagnostic pop
}
#endif

char *makeRandomString(char *keys, size_t length)
{
    char *ptr = malloc(length + 1);
    ptr[length] = 0;
    
    size_t max = strlen(keys) - 1UL;
    for (size_t a = 0; a < length; ++a)
    {
        ptr[a] = keys[RandomNumber(0, max)];
    }
    return ptr;
}

UTF8CHSData *makeRandomStringUTF8CHS(UTF8CHSData *keys, size_t length)
{
    UTF8CHSData *ptr = malloc((length + 1) * sizeof(UTF8CHSData));
    memset(ptr, 0, sizeof(UTF8CHSData));
    
    size_t max = strlen((char *)keys) / sizeof(UTF8CHSData);
    for (size_t a = 0; a < length; ++a)
    {
        ptr[a] = keys[RandomNumber(0, max)];
    }
    
    return ptr;
}

char *makeCharacterWithCount(NSUInteger count, char character)
{
    if (0 == count) return NULL;
    
    count += 1;
    unsigned long x = 0;
    {
        unsigned char *buffer = (unsigned char *)&x;
        for (NSUInteger a = 0; a < sizeof(long); ++a)
        {
            buffer[a] = character;
        }
    }

    NSUInteger lCount = count/sizeof(long);
    if (count % sizeof(long)) lCount += 1;
    
    char *temp = malloc(lCount * sizeof(long));
    
    {
        unsigned long *buffer = (unsigned long *)temp;
        for (NSUInteger a= 0; a < lCount; ++a)
        {
            buffer[a] = x;
        }
    }
    
    temp[count] = 0;
    return temp;
}

#undef SC_SDKInit
BOOL SC_SDKInit(long level, ...)
{
#if USE_NSLOGGER
    LoggerSetViewerHost(NULL, (CFStringRef)@"127.0.0.1", (UInt32)50000);
    LoggerSetViewerHost(NULL, (CFStringRef)@"qokelate.local", (UInt32)50000);
    LoggerSetViewerHost(NULL, (CFStringRef)@"192.168.1.84", (UInt32)50000);
    LoggerSetViewerHost(NULL, (CFStringRef)@"com.sma11case.NSLogger", (UInt32)50000);
#endif
    return YES;
}

BOOL SC_SDKUnInit()
{
    return YES;
}
