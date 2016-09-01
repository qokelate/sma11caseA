//
//  SCConstants.h
//  sma11case
//
//  Created by sma11case on 11/11/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

// 常数宏
#define DeadCode    0xdeadc0deUL
#define PageSize    4096UL
#define MINFLOAT    (1e-999)
#define MINDOUBLE   (1e-999)
#define MAXSHORT    0x7FFF
#define MAXLONG     0x7FFFFFFFL
#define MAXUINT     ((UINT)~((UINT)0))
#define MAXULONG    ((ULONG)~((ULONG)0))
#define MAXINT      ((INT)(MAXUINT >> 1))
#define MININT      ((INT)~MAXINT)
#define RandomNumber(min, max) ((arc4random() % ((max) - (min) + 1)) + (min))
#define PI 3.14159265358979323846

// 初始设置宏
#define MinMutableCount 8UL
#define StringBufferLength 256UL
#define IdentSpace 4

