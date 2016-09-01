//
//  SCNetwork.m
//  sma11case
//
//  Created by sma11case on 8/30/15.
//  Copyright (c) 2015 sma11case. All rights reserved.
//

#import "SCNetwork.h"
#import "../IsRootClass.m"
#import "../Objects/DebugHelper.h"
#import "../Functions.h"
#import "../Category/Category.h"
#import "../Macros.h"
#import <objc/runtime.h>

@implementation SCNetworkInfo

@end


#if 0
+ (CURLcode)curlGetDataWithCURLParam: (CURLParam *)param
{
    CURLGlobalInit();
    
    BOOL cleanupWhenFinished = NO;
    
    if (NULL == param.curl)
    {
        param.curl = curl_easy_init();
        cleanupWhenFinished = YES;
    }
    
    curl_easy_setopt(param.curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
    curl_easy_setopt(param.curl, CURLOPT_NOSIGNAL, 1L);
    curl_easy_setopt(param.curl, CURLOPT_HTTPHEADER, NULL);
    
    NSURL *url = [NSURL URLWithString:param.url];
    curl_easy_setopt(param.curl, CURLOPT_URL, url.absoluteString.UTF8String);
    
    if (param.userName.length)
    {
        curl_easy_setopt(param.curl, CURLOPT_USERNAME, param.userName.UTF8String);
        if (param.password.length) curl_easy_setopt(param.curl, CURLOPT_PASSWORD, param.password.UTF8String);
    }
    
    if (param.userAgent) curl_easy_setopt(param.curl, CURLOPT_USERAGENT, param.userAgent.UTF8String);
    else curl_easy_setopt(param.curl, CURLOPT_USERAGENT, curl_version());
    
    NSString *proxyHost = param.proxyHost;
    NSNumber *proxyPort = @(param.proxyPort);
    
#if USE_SYSTEM_PROXY
    NSDictionary *proxySettings = (__bridge_transfer NSDictionary *)CFNetworkCopySystemProxySettings();
    if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable]
        && [[proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable] boolValue])
    {
        if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy])
            proxyHost = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy];
        
        if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort])
            proxyPort = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort];
    }
#endif
    
    if (proxyHost.length)
    {
        curl_easy_setopt(param.curl, CURLOPT_PROXY, proxyHost.UTF8String);
        curl_easy_setopt(param.curl, CURLOPT_PROXYTYPE, param.proxyType);
        if (proxyPort.unsignedShortValue) curl_easy_setopt(param.curl, CURLOPT_PROXYPORT, proxyPort.unsignedShortValue);
        if (param.proxyUser.length)
        {
            curl_easy_setopt(param.curl, CURLOPT_PROXYUSERNAME, param.proxyUser.UTF8String);
            if (param.proxyPassword.length) curl_easy_setopt(param.curl, CURLOPT_PROXYPASSWORD, param.proxyPassword.UTF8String);
        }
    }
    
    if (param.cookies.length)
    {
        NSMutableString *cookies = [param.cookies mutableCopy];
        [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:param.url]] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger i, BOOL *stop) {
            if ([cookie.path isEqualToString:@"/"] || [cookie.path isEqualToString:url.path])
                [cookies appendFormat:@"%@=%@; ", cookie.name, cookie.value];	// name1=value1; name2=value2; etc.
        }];
        curl_easy_setopt(param.curl, CURLOPT_COOKIE, cookies.UTF8String);
    }
    
    if (param.readCallbackBlock)
    {
        curl_easy_setopt(param.curl, CURLOPT_UPLOAD, 1L);
        curl_easy_setopt(param.curl, CURLOPT_READFUNCTION, ICCurlReadCallback);
        curl_easy_setopt(param.curl, CURLOPT_READDATA, param);
    }
    else  curl_easy_setopt(param.curl, CURLOPT_UPLOAD, 0L);
    
    NSData *dataToSend = nil;
    struct curl_slist *headers = NULL;
    switch (param.mode)
    {
        case CURLRequestModeGet:
            curl_easy_setopt(param.curl, CURLOPT_HTTPGET, 1L);
            break;
            
        case CURLRequestModeHead:
            curl_easy_setopt(param.curl, CURLOPT_NOBODY, 1L);
            break;
            
        case CURLRequestModeOptions:
            curl_easy_setopt(param.curl, CURLOPT_CUSTOMREQUEST, "OPTIONS");
            break;
            
        case CURLRequestModePropfind:
            dataToSend = [@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:propfind xmlns:D=\"DAV:\"><D:allprop/></D:propfind>" dataUsingEncoding:NSUTF8StringEncoding];

            curl_easy_setopt(param.curl, CURLOPT_INFILESIZE, dataToSend.length);
            curl_easy_setopt(param.curl, CURLOPT_IOCTLFUNCTION, ICCurlIoctlCallback);
            curl_easy_setopt(param.curl, CURLOPT_IOCTLDATA, self);
            curl_easy_setopt(param.curl, CURLOPT_CUSTOMREQUEST, "PROPFIND");
            headers = curl_slist_append(headers, "Content-Type: application/xml; charset=\"utf-8\"");
            headers = curl_slist_append(headers, "Depth: 1");
            curl_easy_setopt(param.curl, CURLOPT_HTTPHEADER, headers);
    }
    
    if (param.referer) curl_easy_setopt(param.curl, CURLOPT_REFERER, param.referer.UTF8String);
    
    if (param.followLocation)
    {
        curl_easy_setopt(param.curl, CURLOPT_AUTOREFERER, 1L);
        curl_easy_setopt(param.curl, CURLOPT_FOLLOWLOCATION, 1L);
    }
    
    if (param.notVerifySSL)
    {
        curl_easy_setopt(param.curl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(param.curl, CURLOPT_SSL_VERIFYHOST, 0L);
    }
    
    curl_easy_setopt(param.curl, CURLOPT_WRITEFUNCTION, ICCurlWriteCallback);
    curl_easy_setopt(param.curl, CURLOPT_WRITEDATA, param);
    
#if IS_DEBUG_MODE
    curl_easy_setopt(param.curl, CURLOPT_VERBOSE, 1L);
    curl_easy_setopt(param.curl, CURLOPT_DEBUGFUNCTION, ICCurlDebugCallback);
    curl_easy_setopt(param.curl, CURLOPT_DEBUGDATA, self);
#endif
    
    CurlBlock block = objc_getAssociatedObject(self, &gs_curl_atom);
    if (block) block(param.curl);
    
    CURLcode theResult = curl_easy_perform(param.curl);
    
    if (cleanupWhenFinished)
    {
        curl_easy_cleanup(param.curl);
        param.curl = NULL;
    }
    
    CURLGlobalCleanup();
    
    return theResult;
}
#endif

#if 0
+ (NSData *)postBinarySyncEx:(NSString *)url headers:(NSDictionary *)headers data:(NSData *)data successBlock:(APIResponeBlock)block1 faildBlock:(APIResponeBlock)block2
{
#pragma mark CURL
    
    {
        static bool state = false;
        
        if (false == state) {
            curl_global_init(CURL_GLOBAL_ALL);
            state = true;
        }
    }
    
    NSMutableData *result = [NSMutableData dataWithCapacity:1024];
    
    CURLcode res = CURLE_FAILED_INIT;
    
    {
        ReqInfo info = {0};
        info.data = data.bytes;
        info.length = data.length;
        info.uploaded = 0;
        
        char baseHeaders[128];
        sprintf(baseHeaders, "Content-Length: %lu", (size_t)data.length);
        struct curl_slist *cheaders = curl_slist_append(NULL, baseHeaders);
        cheaders = curl_slist_append(cheaders, "Expect: ");
        
        NSObject *obj = NewClass(NSObject);
        objc_setAssociatedObject(result, info.data, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        CURL *curl = curl_easy_init();
        
        curl_easy_setopt(curl, CURLOPT_URL, [url cStringUsingEncoding:NSUTF8StringEncoding]);
        
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, gs_timeout);
        curl_easy_setopt(curl, CURLOPT_NOSIGNAL, 1);
        curl_easy_setopt(curl, CURLOPT_POST, 1);
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "sma11caseBrowser v1.0");
        
        curl_easy_setopt(curl, CURLOPT_READDATA, &info);
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_callback);
        
        void *ptr = FBridge(result, id, void *);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, ptr);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        
        if (headers.count) {
            for (NSString *key in headers.allKeys) {
                NSString *string = [NSString stringWithFormat:@"%@: %@", key, headers[key]];
                cheaders = curl_slist_append(cheaders, [string cStringUsingEncoding:NSUTF8StringEncoding]);
                
                objc_setAssociatedObject(obj, FBridge(string, id, void *), string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
            curl_easy_setopt(curl, CURLOPT_HTTPHEADER, cheaders);
        }
        
#if UseVerboseLog
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
#endif
        
        enterNetworkActivityIndicatorState();
        
        @try
        {
            res = curl_easy_perform(curl);
        }
        @catch(...)
        {
            [result setData:NewClass(NSData)];
        } @finally {}
        
        leaveNetworkActivityIndicatorState();
        
        curl_easy_cleanup(curl);
        curl_slist_free_all(cheaders);
        
        objc_setAssociatedObject(result, info.data, nil, OBJC_ASSOCIATION_ASSIGN);
    }
    
#if UseVerboseLog
    printf("=================== Network Request ===================\n");
    printf("POST: %s\n", [url cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("Headers: %s\n", [headers.description cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("Data: %s\n", [[data toUTF8String] cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("Result: %s\n", [[[result toJSONObject] description] cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("=======================================================\n");
#endif
    
    if (0 == result.length) {
        LogAnything(res);
        
        if (block2) {
            NSError *error = nil;
            
            if (CURLE_OPERATION_TIMEDOUT == res) {
                error = [NSError errorWithDomain:[NSString stringWithFormat:@"连接服务器超时,请稍候再试."] code:-1001 userInfo:nil];
            } else if (CURLE_OK == res) {
                error = [NSError errorWithDomain:[NSString stringWithFormat:@"服务器没有数据返回."] code:0 userInfo:nil];
            } else {
#ifdef DEBUG
                //                            error = [NSError errorWithDomain:[NSString stringWithFormat:@"连接服务器出错,请稍候再试."] code:0 userInfo:nil];
#endif
            }
            
            block2(nil, error);
        }
        
        return nil;
    }
    
    if (block1) {
        block1(result, nil);
    }
    
    return result;
}
#endif



