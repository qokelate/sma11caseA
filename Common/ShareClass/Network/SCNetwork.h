//
//  SCNetwork.h
//  sma11case
//
//  Created by sma11case on 8/30/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "../Config.h"
#import "../Objects/Objects.h"

typedef size_t(^CURLCallbackBlock)(void *p1, size_t m, void *p2);

extern size_t kCURLInvalidIndex;

void curl_releaseCallback(size_t index);
size_t curl_setCallback(CURL *curl, CURLoption funcOption, CURLoption paramOption, void *param, CURLCallbackBlock block);

@interface SCNetworkInfo : SCModel
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) ushort port;
@end

