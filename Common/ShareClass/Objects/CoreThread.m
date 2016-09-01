//
//  CoreThread.m
//  sma11case
//
//  Created by sma11case on 9/7/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "CoreThread.h"
#import "../Functions.h"
#import "../Category/Category.h"
#import "DebugHelper.h"

@interface CoreThread ()
@end

@implementation CoreThread
{
    char _specific;
    dispatch_queue_t _queue;
}

+ (instancetype)thread
{
    CoreThread *buffer = [[self alloc] init];
    [buffer reset];
    return buffer;
}

- (instancetype)initWithQueue: (dispatch_queue_t)queue
{
    self = [super init];
    if (self)
    {
        NSString *temp = [NSString stringWithFormat:@"_coreThread:%llu", (unsigned long long)[NSDate nowTimeStamp]];
        _queue = queue;
        dispatch_queue_set_specific(_queue, &_specific, &_specific, NULL);
        [self setName:temp];
    }
    return self;
}
- (void)setName:(NSString *)name
{
    _name = name;
    [self runThreadBlock:^{
        [NSThread currentThread].name = name;
    }];
}

- (void)reset
{
    NSString *temp = [NSString stringWithFormat:@"_coreThread:%p", &_specific];
    _queue = dispatch_queue_create(temp.UTF8String, 0);
    dispatch_queue_set_specific(_queue, &_specific, &_specific, NULL);
    [self setName:temp];
}

- (void)runThreadBlockWithWait: (BOOL)wait block:(dispatch_block_t)block
{
    if (nil == block) return;
    
    void *value = dispatch_get_specific(&_specific);
    
    if (value == &_specific)
    {
        block();
        return;
    }
    
    __block BOOL busy = YES;
    dispatch_async(_queue, ^{
        block();
        busy = NO;
    });
    while (wait && busy) MinSleep();
}

- (void)runThreadBlock:(dispatch_block_t)block
{
    [self runThreadBlockWithWait:NO block:block];
}

- (void)runThreadBlock: (dispatch_block_t)block mainBlock: (dispatch_block_t)sblock
{
    [self runThreadBlock:^{
        block();
        dispatch_async(dispatch_get_main_queue(), sblock);
    }];
}

- (void)runMainBlock: (dispatch_block_t)block threadBlock: (dispatch_block_t)sblock
{
    if ([NSThread isMainThread])
    {
        block();
        dispatch_async(_queue, sblock);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
        dispatch_async(_queue, sblock);
    });
}
@end
