//
//  DebugHelper.h
//  ibosvip
//
//  Created by sma11case on 15/8/4.
//  Copyright (c) 2015年 ibos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCObject.h"
#import "SCModel.h"
#import "../Macros.h"

#define MaxStackCount 128

#if IS_DEBUG_MODE
#define LogObject(...) logObject(__VA_ARGS__, nil)
#define LogStacks() printStacks()
#define LogWhoCallMe() MLog(@"---> %@", getStacksInfoWithIndex(2))
#define PrintAppInfo() printAppInfo()
#else
#define LogObject(...)
#define LogStacks()
#define LogWhoCallMe()
#define PrintAppInfo()
#endif

@interface StackInfoModel : SCModel
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *functionName;
@property (nonatomic, assign) NSUInteger lineNumber;

+ (instancetype)modelWithString: (NSString *)string;
- (void)updateWithString: (NSString *)string;
@end

StackInfoModel *getStacksInfoWithIndex(unsigned int index);
NSMutableArray *stacksInfoWithLevel(unsigned int level);

void logObject(id arg, ...);
#define logObject(...) logObject(__VA_ARGS__, nil)

#if PLAT_IOS
void printAppInfo();
#endif
