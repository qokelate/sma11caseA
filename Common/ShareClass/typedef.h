//
//  typedef.h
//  sma11case
//
//  Created by sma11case on 15/8/18.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#if PLAT_IOS
typedef unsigned long ULONG;
#endif

typedef char   CHAR;
typedef short  SHORT;
typedef int    INT;
typedef long   LONG;
typedef float  FLOAT;
typedef double DOUBLE;
typedef unsigned int   UINT;
typedef unsigned short USHORT;
typedef unsigned long long ULongLong;

typedef void(^EmptyBlock)();
typedef NSString*(^GetStringBlock)();

typedef void(^SelectorBlock)(id target, SEL selector, id sender);
typedef void(^BoolBlock)(BOOL state);
typedef void(^VAListBlock)(ULONG first, ...);
typedef void(^NSObjectBlock)(id object);
typedef void(^DictionaryBlock) (NSDictionary *respone);
typedef void(^ArrayBlock) (NSArray *respone);
typedef void(^NetResponeBlock)(id respone, NSError *error);
typedef void(^NetDictionaryResponeBlock)(NSDictionary *respone, NSError *error);
typedef void(^NetJsonResponeBlock)(id respone, NSError *error);

typedef struct _UTF8CHSData
{
    unsigned char data[3];
}UTF8CHSData;

union UTF8CHS
{
    UTF8CHSData data;
    unsigned char bytes[sizeof(UTF8CHSData)];
};
