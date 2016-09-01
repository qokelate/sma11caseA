//
//  IsRootClass.m
//  sma11case
//
//  Created by sma11case on 15/8/11.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#ifndef SC_Library_IsRootClass_m
#define SC_Library_IsRootClass_m

#define isRootClass __forwarding_check

#define DefIsRootClass() + (BOOL)isRootClass
#define ImpIsRootClass(x)  + (BOOL)isRootClass\
{\
    if ([self class] == [x class]) return YES;\
    if ([NSStringFromClass([self class]) isEqualToString:NSStringFromClass([x class])]) return YES;\
    return NO;\
}

#define IsRootClass(x) ([[x class] isSubclassOfClass: [SCObject class]] ? (long)[x performSelector:@selector(isRootClass)] : NO)

#endif
