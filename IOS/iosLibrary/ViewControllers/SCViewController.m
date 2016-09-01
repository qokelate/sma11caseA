//
//  SCViewController.m
//  sma11case
//
//  Created by sma11case on 15/8/22.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "SCViewController.h"
#import "../../../Common/ShareClass/ShareClass.h"
#import "../ExternalsSource/ExternalsSource.h"
#import "../Category/Category.h"

@interface SCViewController ()
@property (nonatomic, assign) ViewControllerState viewState;
@end

@implementation SCViewController
{
    char _navigationBarState;
}

#if IS_DEBUG_MODE
ImpDebugAllocMethod()
#endif

- (void)dealloc
{
    MLog(@"%p <%@:%@> dealloc", self, [self class], self.superclass);
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewState = ViewControllerDidLoad;
    
    if (_navigationBarState) self.navigationController.navigationBarHidden = (_navigationBarState - 1);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    
    self.viewState = ViewControllerWillAppear;
    
    if (_navigationBarState) self.navigationController.navigationBarHidden = (_navigationBarState - 1);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    self.viewState = ViewControllerDidAppear;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Do any additional setup after loading the view.
    
    self.viewState = ViewControllerWillDisappear;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Do any additional setup after loading the view.
    
    self.viewState = ViewControllerDidDisappear;
}

- (BOOL)isVisible
{
    if (ViewControllerWillAppear == _viewState || ViewControllerDidAppear == _viewState)
    {
        return (self.isViewLoaded && self.view.window);
    }
    return NO;
}

- (void)setNavigationBarHidden: (BOOL)state
{
    _navigationBarState = (state ? 2 : 1);
    self.navigationController.navigationBarHidden = state;
}

ImpDescriptionMethod()

#if IS_DEBUG_MODE
- (void)setViewState:(ViewControllerState)viewState
{
    _viewState = viewState;
    MLog(@"%p <%@:%@> viewState = %lu", self, [self class], self.superclass, (ULONG)_viewState);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#endif

@end
