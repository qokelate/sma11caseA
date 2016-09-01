//
//  NSThread+SC.h
//  sma11case
//
//  Created by lianlian on 8/30/16.
//
//

#import <Foundation/Foundation.h>
#import "../Config.h"

#define PrintFunctionName() do{\
NSString *call = [[NSThread callStackSymbols][0] substringFromIndex:40];\
NSString *temp = [NSString stringWithFormat:@"tid:%02d %@", [NSThread currentThread].seqNumber, call];\
printf("%s\n", [temp cStringUsingEncoding:NSUTF8StringEncoding]);\
}while(0)

#if IS_DEBUG_MODE
#define LogFunctionName() PrintFunctionName()
#else
#define LogFunctionName()
#endif

@interface NSThread(sma11case_shareClass)
- (int)seqNumber;
@end
