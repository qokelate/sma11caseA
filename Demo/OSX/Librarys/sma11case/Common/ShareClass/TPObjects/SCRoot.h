//
//  SCRoot.h
//  sma11case
//
//  Created by sma11case on 11/22/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_ROOT_CLASS
@interface SCRoot
+ (instancetype)new;
+ (instancetype)alloc;
- (instancetype)init;

- (Class)superclass;
- (Class)class;
- (id)self;
- (NSString *)description;

- (void)dealloc;
+ (Class)class;
+ (Class)superclass;
+ (NSString *)description;
+ (BOOL)isSubclassOfClass: (Class)aClass;
@end
