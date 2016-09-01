//
//  NSNotificationCenter+SC.h
//  sma11case
//
//  Created by lianlian on 8/31/16.
//
//

#import <Foundation/Foundation.h>

typedef void(^NotifyBlock)(NSNotification *notify);

@interface NSNotificationCenter(sma11case_shareClass)
- (void)addObserverSafe:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
@end
