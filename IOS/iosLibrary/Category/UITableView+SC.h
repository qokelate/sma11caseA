//
//  UITableView+SC.h
//  sma11case
//
//  Created by sma11case on 12/1/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(sma11case_IOS)
- (void)reloadDataWithCompletion: (dispatch_block_t)block; // support async call
- (UIControl *)tableIndexView; // 需要注意调用时机,在cellForRowAtIndexPath调用最适合
@end
