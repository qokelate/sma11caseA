//
//  FireFoxBookmarkManager.h
//  sma11case
//
//  Created by sma11case on 11/8/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../osxLibrary/staticLibrary_OSX.h"

@interface FireFoxBookmarkModel : SCModel
@property (nonatomic, assign) NSInteger lastModified;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger dateAdded;
@property (nonatomic, strong) NSArray *annos;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, assign) NSInteger index;
@end

@interface FireFoxBookmarkManager : NSObject
+ (NSDictionary *)loadBookmarksWithFile: (NSString *)file;
+ (BOOL)saveBookmark: (NSDictionary *)json toFile: (NSString *)file;

+ (NSMutableDictionary *)removeDuplicationElement: (NSDictionary *)bookmark;
+ (NSMutableDictionary *)mergeBookmarksWithVAList: (NSDictionary *)first, ...;

+ (id)copyAsMutable: (id)object;
@end
