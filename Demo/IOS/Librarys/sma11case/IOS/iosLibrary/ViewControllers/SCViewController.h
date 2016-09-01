//
//  SCViewController.h
//  sma11case
//
//  Created by sma11case on 15/8/22.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerConstants.h"

@interface SCViewController : UIViewController
@property (nonatomic, assign, readonly) BOOL isVisible;
@property (nonatomic, assign, readonly) ViewControllerState viewState;

- (void)setNavigationBarHidden: (BOOL)state;
@end
