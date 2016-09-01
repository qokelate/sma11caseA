//
//  UITableView+SC.m
//  sma11case
//
//  Created by sma11case on 12/1/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UITableView+SC.h"
#import "../Config.h"

@implementation UITableView(sma11case_IOS)
- (UIControl *)tableIndexView
{
    return [self findSubviewWithClass:NSClassFromString(@"UITableViewIndex") maxCount:1][0];
}
@end
