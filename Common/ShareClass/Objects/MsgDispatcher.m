//
//  MsgDispatcher.m
//  sma11case
//
//  Created by sma11case on 15/8/14.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "MsgDispatcher.h"
#import "../Macros.h"
#import "../Functions.h"
#import "DebugHelper.h"
#import "../IsRootClass.m"
#import "WeakArray.h"

#define SCLog(...) //MLog(__VA_ARGS__)

NSString *const MsgTypeMsgDispatcherDealloc = @"MsgTypeMsgDispatcherDealloc";

@implementation MsgDispatcher
{
    NSMutableDictionary *_receivers;
}

ImpIsRootClass(MsgDispatcher)

- (void)dealloc
{
    [self postMessage:MsgTypeMsgDispatcherDealloc userParam:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _receivers = NewMutableDictionary();
    }
    return self;
}

- (BOOL)addReceiver: (id<MsgDispatcherDelegate>)obj type: (NSString *)type
{
    WeakArray *temp = _receivers[type];
    if (nil == temp)
    {
        temp = NewWeakArray();
        [_receivers setObject:temp forKey:type];
    }
    [temp addObject:obj autoRemove:YES];
    return YES;
}

- (void)removeReceiver: (id)obj
{
    for (NSString *type in _receivers.allKeys)
    {
        [self removeReceiver:obj type:type];
    }
}

- (void)removeReceiver: (id)obj type: (NSString *)type
{
    WeakArray *temp = _receivers[type];
    if (nil == temp) return;
    
    [temp removeObject:obj];
}

- (void)postMessageToAllReceiversWithUserParam: (id)param
{
    for (NSString *key in _receivers.allKeys)
    {
        [self postMessage:key userParam:param];
    }
}

- (void)postMessage: (NSString *)type userParam: (id)param
{
    WeakArray *temp = _receivers[type];
    if (nil == temp) return;
    
    for (id<MsgDispatcherDelegate> obj in temp)
    {
        [obj didReceivedMessage:type from:self userParam:param];
    }
}

@end
