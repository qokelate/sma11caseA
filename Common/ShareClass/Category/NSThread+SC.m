//
//  NSThread+SC.m
//  sma11case
//
//  Created by lianlian on 8/30/16.
//
//

#import "NSThread+SC.h"
#import "../Functions.h"

@implementation NSThread(sma11case_shareClass)
- (int)seqNumber
{
    __unsafe_unretained NSObject *td = nil;
    getIvarValue(self, "_private", sizeof(td), &td);
    
    char tid = 0;
    getIvarValue(td, "seqNum", sizeof(tid), &tid);
    return tid;
}
@end
