//
//  CoreThread.h
//  sma11case
//
//  Created by sma11case on 9/7/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCObject.h"

@interface CoreThread : NSObject
@property (nonatomic, strong) NSString *name;

+ (instancetype)thread;
- (instancetype)initWithQueue: (dispatch_queue_t)queue;
- (void)runThreadBlock: (dispatch_block_t)block;
- (void)runThreadBlockWithWait: (BOOL)wait block:(dispatch_block_t)block;
- (void)runThreadBlock: (dispatch_block_t)block mainBlock: (dispatch_block_t)sblock;
- (void)runMainBlock: (dispatch_block_t)block threadBlock: (dispatch_block_t)sblock;

#if DisableNRM
- (instancetype)init SC_DISABLED;
#endif
@end
