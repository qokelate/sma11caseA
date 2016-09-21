//
//  AppDelegate.m
//  sma11case
//
//  Created by sma11case on 1/27/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "AppDelegate.h"
#import "SCCodeHelper.h"
#import "FireFoxBookmarkManager.h"
#import "../osxLibrary/staticLibrary_OSX.h"

extern int g_argc;
extern const char **g_argv;

/*
 "enabled" : 1,
 "blackList" : 0,
 "multiLine" : 0,
 "pattern" : "^http\:.*21andy\.com\/blog",
 "isRegEx" : 1,
 "caseSensitive" : 0,
 "name" : "^http\:.*21andy\.com\/blog"
 */
@interface FoxyProxyModel : SCModel
@property (nonatomic, assign) BOOL isRegEx;
@property (nonatomic, strong) NSString *pattern;
@end

@implementation FoxyProxyModel
@end

@implementation AppDelegate
+ (void)launchWithArgc: (NSUInteger)argc argv: (const char **)argv
{
    [self fix_ios10_xib];
}

+ (void)fix_ios10_xib
{
    NSString *path = @"/Users/xxxxxxxxxxxxxxxxxxx";
    
    [NSFM enumFilesWithPath:path block:^BOOL(NSString *dirPath, NSString *fileName, BOOL isDir) {
        if (isDir) return YES;
        
        if (NO == [fileName hasSuffix:@"xib"]
            && NO == [fileName hasSuffix:@".nib"]
            && NO == [fileName hasSuffix:@".storyboard"]) return YES;
        
        NSString *file = [NSString stringWithFormat:@"%@/%@", dirPath, fileName];
        NSMutableString *code = [NSMutableString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL];
        
        MLog(@"process: %@", file);
        
        NSArray *fonts = nil;
        do{
            fonts = [code regexpMatchResults:@" pointSize=\"[\\d\\.]+\""];
            if (0 == fonts.count) break;
            
            NSTextCheckingResult *exp = fonts.firstObject;
            NSString *line = [code substringWithRange:exp.range];
            double weight = [line regexpFirstMatch:@"\\d+"].doubleValue;
            double nweight = weight * 17.0 / 17.5;
            NSString *nline = [NSString stringWithFormat:@" pointSize=\"%.1lf<sma11caseFont>\"", nweight];
            [code replaceCharactersInRange:exp.range withString:nline];
            MLog(@"%@ => %@", line, nline);
            BreakPointHere;
        }while (fonts.count);
        
        [code replaceOccurrencesOfString:@"<sma11caseFont>" withString:@"" options:0 range:NSMakeRange(0, code.length)];
        [code writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        BreakPointHere;
        return YES;
    }];
}

@end


