//
//  MsgDispatcher.h
//  sma11case
//
//  Created by sma11case on 15/8/14.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#define sMsgTypeUnknow "MsgTypeUnknow"
extern NSString *const MsgTypeMsgDispatcherDealloc;

@class MsgDispatcher;
@protocol MsgDispatcherDelegate <NSObject>
@required
- (void)didReceivedMessage: (NSString *)type from: (MsgDispatcher *)sender userParam: (id)param;
@end

@interface MsgDispatcher : NSObject
- (void)removeReceiver: (id)obj;
- (void)removeReceiver: (id)obj type: (NSString *)type;
- (BOOL)addReceiver: (id<MsgDispatcherDelegate>)obj type: (NSString *)type;

- (void)postMessage: (NSString *)type userParam: (id)param;
- (void)postMessageToAllReceiversWithUserParam: (id)param;
@end
