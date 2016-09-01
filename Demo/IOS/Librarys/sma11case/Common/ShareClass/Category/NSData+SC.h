//
//  NSData+SC.h
//  sma11case
//
//  Created by sma11case on 9/6/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(sma11case_ShareClass)
- (id)unarchiveData;
- (id)toJSONObject;
- (NSString *)toUTF8String;
- (NSString *)toStringWithEncoding: (NSStringEncoding)code;
- (NSString *)base64Encode;
@end
