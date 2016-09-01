//
//  ImageRenamer.h
//  sma11case
//
//  Created by sma11case on 11/13/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../osxLibrary/staticLibrary_OSX.h"

@interface ImageRenamer : SCObject
+ (void)formatNameWithPath: (NSString *)path param: (id)param;
@end
