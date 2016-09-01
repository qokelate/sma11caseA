//
//  UITableViewCell+SC.h
//  sma11case
//
//  Created by sma11case on 12/12/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

@interface UITableViewCell(sma11case_IOS)
+ (CGFloat)height;
+ (NSString *)cellId;
+ (NSString *)cellIdWithStyle: (UITableViewCellStyle)style;
+ (instancetype)cellForTableView: (UITableView *)tableView;
+ (instancetype)cellForTableView: (UITableView *)tableView style: (UITableViewCellStyle)style;

#if DisableNRM
+ (instancetype)new SC_DISABLED;
+ (instancetype)alloc SC_DISABLED;
- (instancetype)init SC_DISABLED;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier SC_DISABLED;
- (instancetype)initWithCoder:(NSCoder *)aDecoder SC_DISABLED;
- (instancetype)initWithFrame:(CGRect)frame SC_DISABLED;
- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier SC_DISABLED;
#endif
@end
