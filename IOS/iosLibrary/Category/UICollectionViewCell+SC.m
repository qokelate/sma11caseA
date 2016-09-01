//
//  UICollectionViewCell+SC.m
//  sma11case
//
//  Created by sma11case on 12/20/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "UICollectionViewCell+SC.h"
#import <objc/runtime.h>

MakeStaticChar(gs_registed_class);

@implementation UICollectionViewCell(sma11case_IOS)
+ (CGSize)size
{
    return CGSizeZero;
}

+ (NSString *)cellId
{
    return NSStringFromClass(self);
}

+ (UICollectionViewCell *)cellForCollectionView: (UICollectionView *)collectionView indexPath: (NSIndexPath *)indexPath
{
    if (nil == objc_getAssociatedObject(collectionView, &gs_registed_class))
    {
        objc_setAssociatedObject(collectionView, &gs_registed_class, self, OBJC_ASSOCIATION_ASSIGN);
        [collectionView registerClass:self forCellWithReuseIdentifier:[self cellId]];
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self cellId] forIndexPath:indexPath];
}
@end
