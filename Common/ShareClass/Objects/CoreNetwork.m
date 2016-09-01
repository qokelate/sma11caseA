/*
 *
 *  CoreNetwork.m
 *  sma11case
 *
 *  Created by sma11case on 15/8/18.
 *  Copyright (c) 2015年 sma11case. All rights reserved.
 *
 */

#import "CoreNetwork.h"
#import "../Model/Model.h"
#import "../Functions.h"
#import "../IsRootClass.m"
#import "../Category/Category.h"

#define SCLog(...) MLog(__VA_ARGS__)

static size_t gs_curl_init = 0;

NSString *urlEncode(NSString *string)
{
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    char *str2 = curl_easy_escape(NULL, str, (int)strlen(str));
    NSString *res = [NSString stringWithCString:str2 encoding:NSUTF8StringEncoding];
    curl_free(str2);
    return res;
}

NSData *urlDecode(NSString *string)
{
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int len = 0;
    char *str2 = curl_easy_unescape(NULL, str, (int)strlen(str), &len);
    NSData *res = [NSData dataWithBytes:str2 length:len];
    curl_free(str2);
    return res;
}

NSString *mergeRequestURL(NSString *baseURL, NSDictionary *getParam)
{
    NSString *path = baseURL;
    if ( getParam.count )
    {
        NSMutableString *buffer = [NSMutableString stringWithCapacity:StringBufferLength];
        [buffer appendString:baseURL];
        
        BOOL state = NO;
        for (NSString *key in getParam.allKeys)
        {
            NSString *value = getParam[key];
            
            if (state)
            {
                [buffer appendFormat:@"&%@=%@", key, URLEncode( value )];
                continue;
            }
            
            state = YES;
            [buffer appendFormat:@"?%@=%@", key, URLEncode( value )];
        }
        
        path = buffer;
    }
    return path;
}

static size_t curl_read(char *a, size_t b, size_t c, void *d)
{
    size_t *info = FType(size_t*, d);
    char *bytes = (char*)info[0];
    size_t length = info[1];
    size_t used = info[2];
    size_t remain = length - used;
    
    if (0 == remain) return 0;
    
    size_t res = b * c;
    
    if (remain >= res)
    {
        info[2] += res;
        memcpy(a, bytes+used, res);
        return res;
    }
    
    info[2] += remain;
    memcpy(a, bytes+used, remain);
    
    return remain;
}

CURLcode ftp_upload(NSString *url, NSString *username, NSString *password, NSData *data, FTPUploadBlock block)
{
    if (0 == data.length) return CURLE_FAILED_INIT;
    
    if (0 == gs_curl_init++) curl_global_init(CURL_GLOBAL_ALL);
    
    CURL *curl = curl_easy_init();
    
    size_t info[] = {FType(size_t, data.bytes), data.length, 0};
    
    curl_easy_setopt(curl, CURLOPT_URL, [url cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (nil == username && password)
    {
         curl_easy_setopt(curl, CURLOPT_USERPWD, [password cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    else if (username && password)
    {
        curl_easy_setopt(curl, CURLOPT_USERNAME, [username cStringUsingEncoding:NSUTF8StringEncoding]);
        curl_easy_setopt(curl, CURLOPT_PASSWORD, [password cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    curl_easy_setopt(curl, CURLOPT_READDATA, info);
    curl_easy_setopt(curl, CURLOPT_INFILESIZE, data.length);
    curl_easy_setopt(curl, CURLOPT_READFUNCTION, curl_read);
    curl_easy_setopt(curl, CURLOPT_UPLOAD, 1);
    curl_easy_setopt(curl, CURLOPT_FTP_CREATE_MISSING_DIRS, 1);
//    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
    
    CURLcode ret = curl_easy_perform(curl);
    
    if (block) block(curl, ret);
    
    curl_easy_cleanup(curl);
    
    return ret;
}



