//
//  NSTimer+SC.m
//  sma11case
//
//  Created by sma11case on 11/25/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "NSTimer+SC.h"
#import "../Macros.h"
#import "NSObject+SC.h"
#import "NSString+SC.h"
#import "../Functions.h"
#import "../Objects/DebugHelper.h"
#import "../TPObjects/TPObjects.h"

#if UseExpeAPI
@implementation NSTimer(sma11case_ShareClass)
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti unretainTarget:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    SCBlock *block = NewClass(SCBlock);

    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:block selector:@selector(objectSelector:) userInfo:userInfo repeats:yesOrNo];
    
    CopyAsWeak(aTarget, wTarget);
    
    [block setSelectorWithParam:timer block:^(NSTimer *sender) {
        if (nil == wTarget)
        {
            MLog(@"%p <%@:%@> invalidate", sender, [sender class], [sender superclass]);
            [sender invalidate];
            return ;
        }
        
        sc_SendMessage0(wTarget, aSelector, sender);
    }];
    
    return timer;
}
@end
#endif
