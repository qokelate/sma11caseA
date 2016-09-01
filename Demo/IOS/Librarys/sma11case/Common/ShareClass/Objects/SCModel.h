//
//  SCModel.h
//  sma11case
//
//  Created by sma11case on 15/8/23.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import "SCObject.h"

typedef id(^SetValueBlock)(NSString *name, NSString *attribute, BOOL *notUpdate);

@interface SCModel : NSObject <NSCoding>
@property (nonatomic, strong, readonly) NSMutableDictionary *dictionary;

+ (BOOL)cachePropertyList;

+ (instancetype)modelWithDictionary: (NSDictionary *)dictionary;
- (void)updateWithDictionary: (NSDictionary *)dictionary;

- (NSMutableDictionary *)dictionaryWithKeys: (NSArray *)keys;
- (NSMutableDictionary *)dictionaryWithRecursive: (BOOL)recursive;
@end
