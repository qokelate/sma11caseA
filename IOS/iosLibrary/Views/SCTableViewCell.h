//
//  SCTableViewCell.h
//  sma11case
//
//  Created by sma11case on 10/25/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

typedef void(^CustomDeleteViewBlock)(UIView *view, UIButton *button);

@interface SCTableViewCell : UITableViewCell
- (void)setCustomDeleteViewBlock:(CustomDeleteViewBlock)customDeleteViewBlock;
@end
