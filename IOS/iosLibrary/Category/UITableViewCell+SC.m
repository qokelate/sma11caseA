//
//  UITableViewCell+SC.m
//  sma11case
//
//  Created by sma11case on 12/12/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UITableViewCell+SC.h"

@implementation UITableViewCell(sma11case_IOS)

+ (CGFloat)height
{
    return 0.0f;
}

+ (NSString *)cellId
{
    return [self cellIdWithStyle:UITableViewCellStyleDefault];
}

+ (NSString *)cellIdWithStyle: (UITableViewCellStyle)style
{
    if (UITableViewCellStyleDefault == style) return NSStringFromClass(self);
    return [NSString stringWithFormat:@"%@,%ld", NSStringFromClass(self), (long)style];
}

+ (UITableViewCell *)cellForTableView: (UITableView *)tableView
{
    return [self cellForTableView:tableView style:UITableViewCellStyleDefault];
}

+ (UITableViewCell *)cellForTableView: (UITableView *)tableView style: (UITableViewCellStyle)style
{
    NSString *temp = [self cellIdWithStyle:style];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:temp];
    if (nil == cell)
    {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:temp];
    }
    return cell;
}
@end
