//
//  SCLogger.h
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import <Foundation/Foundation.h>

typedef void(^SCLoggerBlock)(NSThread *thread, NSArray *stacks, NSTimeInterval deltaTime);

@interface SCLogger : NSObject
- (instancetype)initWithQueue: (dispatch_queue_t)queue;

- (void)log: (SCLoggerBlock)block;
@end
