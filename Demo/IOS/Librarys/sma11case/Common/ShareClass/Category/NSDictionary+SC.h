//
//  NSDictionary+SC.h
//  sma11case
//
//  Created by sma11case on 8/30/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(sma11case_ShareClass)
- (NSData *)toData;
- (NSString *)toJsonString;
@end
