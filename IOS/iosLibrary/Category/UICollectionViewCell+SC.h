//
//  UICollectionViewCell+SC.h
//  sma11case
//
//  Created by sma11case on 12/20/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Config.h"

@interface UICollectionViewCell(sma11case_IOS)
+ (CGSize)size;
+ (NSString *)cellId;
+ (instancetype)cellForCollectionView: (UICollectionView *)collectionView indexPath: (NSIndexPath *)indexPath;

#if DisableNRM
+ (instancetype)new SC_DISABLED;
+ (instancetype)alloc SC_DISABLED;
- (instancetype)init SC_DISABLED;
- (instancetype)initWithCoder:(NSCoder *)aDecoder SC_DISABLED;
- (instancetype)initWithFrame:(CGRect)frame SC_DISABLED;
#endif
@end
