//
//  NSDate+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (sma11case_ShareClass)
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isThisYear;
- (NSDate *)dateWithYMD;
- (NSDate *)dateWithFormat: (NSString *)format;
- (NSString *)dateStringWithFormat: (NSString *)format;
- (NSDateComponents *)deltaToNow;
+ (NSTimeInterval)nowTimeStamp;
@end
