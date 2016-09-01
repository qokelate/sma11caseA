//
//  SCNetwork.h
//  sma11case
//
//  Created by sma11case on 8/30/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "../Config.h"
#import "../Objects/Objects.h"

@interface SCNetworkInfo : SCModel
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) ushort port;
@end

