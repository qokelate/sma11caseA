//
//  SCCodeHelper.h
//  sma11case
//
//  Created by sma11case on 2/18/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultSourceTypes @[@".h", @".hpp", @".hxx", @".c", @".cpp", @".cxx", @".m", @".mm"]

@interface SCCodeHelper : NSObject
+ (void)fixHeaderWithSourceFolder: (NSString *)sourceDir fileTypes: (NSArray *)types ignoringCase: (BOOL)icase;
+ (void)fixHeaderWithSourceFiles: (NSArray *)files validFiles: (NSArray *)sourceFiles rootDir: (NSString *)root;
@end
