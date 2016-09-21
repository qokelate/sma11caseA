//
//  DebugHelper.m
//  sma11casevip
//
//  Created by sma11case on 15/8/4.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "DebugHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "../Functions.h"
#import "../IsRootClass.m"
#import "../Category/Category.h"

#if PLAT_IOS
#import <UIKit/UIDevice.h>
#endif

#define SCLog(...) NSLog(__VA_ARGS__)

@implementation StackInfoModel
+ (instancetype)modelWithString: (NSString *)string
{
    StackInfoModel *model = NewClass(self);
    [model updateWithString:string];
    return model;
}

- (void)updateWithString: (NSString *)string
{
    self.index = FType(NSString *, [string regexpFirstMatch:@"^\\d+"]).integerValue;
    self.moduleName = [string regexpFirstMatch:@"[_A-Za-z\\?][\\?\\w\\.]+"];
    self.address = [string regexpFirstMatch:@"0x[a-fA-F0-9]+"];
    self.functionName = [string regexpFirstMatch:@"0x[a-fA-F0-9]+[\\s\\S]+$"];
    self.lineNumber = FType(NSString *, [string regexpFirstMatch:@"\\d+$"]).integerValue;
    
    if (self.functionName.length)
    {
        self.functionName = [self.functionName regexpReplace:@"^0x[a-fA-F0-9]+\\s+" replace:@""];
        self.functionName = [self.functionName regexpReplace:@"\\s+\\+\\s+\\d+$" replace:@""];
    }
}
@end

StackInfoModel *getStacksInfoWithIndex(unsigned int index)
{
    void* callstack[index + 1];
    int frames = backtrace(callstack, index + 1);
    if (0 == frames) return nil;
    
    char **strs = backtrace_symbols(callstack, frames);
    NSString *temp = [NSString stringWithUTF8String:strs[index]];
    StackInfoModel *model = [StackInfoModel modelWithString:temp];

    free(strs);
    return model;
}

NSMutableArray *stacksInfoWithLevel(unsigned int level)
{
    void* callstack[level];
    int frames = backtrace(callstack, level);
    if (0 == frames) return nil;
    
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (NSUInteger i = 0; i < frames; ++i)
    {
        NSString *temp = [NSString stringWithUTF8String:strs[i]];
        StackInfoModel *model = [StackInfoModel modelWithString:temp];
        [backtrace addObject:model];
    }
    free(strs);
    
    return backtrace;
}

void printStacks()
{
    long lineCount = 3;
    for (long a = 0; a < lineCount; ++a)
    {
       SCLog(@"==================================================");
    }
    
   SCLog(@"============== Will Print Stacks =================");
   SCLog(@"==================================================");
    
    void* callstack[MaxStackCount];
    int frames = backtrace(callstack, MaxStackCount);
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0;i < frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
   SCLog(@"%@",backtrace);
    
   SCLog(@"==================================================");
   SCLog(@"============== End Print Stacks =================");
    for (long a = 0; a < lineCount; ++a)
    {
       SCLog(@"==================================================");
    }
}

#undef logObject
void logObject(id arg, ...)
{
    va_list ap;
    va_start(ap, arg);

    while (arg)
    {
       SCLog(@"%@", arg);
        arg = va_arg(ap, id);
    }
}

#if PLAT_IOS
void printAppInfo()
{
    //手机序列号
//    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
//   SCLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
   SCLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
   SCLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
   SCLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
   SCLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
   SCLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
   SCLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
   SCLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
   SCLog(@"当前应用版本号码：%@",appCurVersionNum);
}
#endif



