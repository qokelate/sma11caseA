//
//  SCLogger.m
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import "SCLogger.h"
#import "../Category/Category.h"

@implementation SCLogger
{
    NSTimeInterval _lastTime;
    dispatch_queue_t _queue;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _lastTime = [NSDate nowTimeStamp];
        _queue = dispatch_queue_create("sma11case.logger.queue", NULL);
    }
    return self;
}

- (instancetype)initWithQueue: (dispatch_queue_t)queue
{
    if (self = [super init])
    {
        _queue = queue;
        _lastTime = [NSDate nowTimeStamp];
        
        if (nil == _queue)
        {
            _queue = dispatch_queue_create("sma11case.logger.queue", NULL);
        }
    }
    return self;
}

- (void)log: (SCLoggerBlock)block
{
    NSTimeInterval  now = [NSDate nowTimeStamp];
    NSThread        *thread = [NSThread currentThread];
    NSArray         *stacks = [NSThread callStackSymbols];
    
    NSTimeInterval delta = now - _lastTime;
    _lastTime = now;
    
    dispatch_async(_queue, ^{
        block(thread, stacks, delta);
    });
}
@end
