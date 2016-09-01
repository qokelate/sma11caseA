
//
//  ViewControllerConstants.h
//  sma11case
//
//  Created by sma11case on 15/8/22.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ViewControllerState)
{
    ViewControllerStateUnknow = 0,
    ViewControllerDidLoad = 1<<0,
    ViewControllerWillAppear = 1<<1,
    ViewControllerDidAppear = 1<<2,
    ViewControllerWillDisappear = 1<<3,
    ViewControllerDidDisappear = 1<<4
};

