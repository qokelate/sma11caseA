//
//  CoreNetwork.h
//  sma11case
//
//  Created by sma11case on 15/8/18.
//  Copyright (c) 2015年 sma11case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../ExternalsLibrary/ExternalsLibrary.h"

#define GetAFNErrorRespone(x) [x.userInfo[@"com.alamofire.serialization.response.error.data"] toUTF8String]
#define GetAFNErrorRequest(x) x.userInfo[@"com.alamofire.serialization.response.error.response"]
#define LogAFNErrorRespone(x) MLog(@"AFN error respone:\n%@", GetAFNErrorRespone(x))
#define LogAFNErrorRequest(x) MLog(@"AFN error request:\n%@", GetAFNErrorRequest(x))

// 编码宏
#define URLEncode(x)  [(x) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define URLDecode(x)  urlDecode(x)

NSString *mergeRequestURL(NSString *baseURL, NSDictionary *getParam);

NSData *urlDecode(NSString *string);
NSString *urlEncode(NSString *string);

typedef void(^FTPUploadBlock)(CURL *curl, CURLcode result);
CURLcode ftp_upload(NSString *url, NSString *username, NSString *password, NSData *data, FTPUploadBlock block);


