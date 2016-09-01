//
//  SCObject.h
//  sma11case
//
//  Created by sma11case on 15/8/19.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Macros.h"

#define SCObjectClass [SCObject class]

@interface SCObject : NSObject
@property (nonatomic, strong, readonly) NSDictionary *properties;

#if DisableNRM
+ (instancetype)new SC_DISABLED;
#endif
@end

