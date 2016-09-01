//
//  MWFeedParser+SC.m
//  sma11case
//
//  Created by sma11case on 8/19/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "MWFeedParser+SC.h"

#if UseMWFeedParser
@interface MWFeedParser()
- (void)reset;
- (void)parsingFailedWithErrorCode:(int)code andDescription:(NSString *)description;
@end

@implementation MWFeedParser(sma11case_ShareClass)
+ (void)parseWithData: (NSData *)data delegate:(id<MWFeedParserDelegate>)delegate
{
    MWFeedParser *temp = [[self alloc] init];
    temp.feedParseType = ParseTypeFull;
    [temp parseWithData:data delegate:delegate];
}

+ (void)parseWithURL: (NSURL *)url delegate:(id<MWFeedParserDelegate>)delegate
{
    MWFeedParser *p = [[self alloc] initWithFeedURL:url];
    p.delegate = delegate;
    p.feedParseType = ParseTypeFull;
    p.connectionType = ConnectionTypeAsynchronously;
    [p parse];
}

- (void)parseWithData: (NSData *)data delegate:(id<MWFeedParserDelegate>)parserDelegate
{
    NSXMLParser *temp = [[NSXMLParser alloc] initWithData:data];
    if (temp)
    {
        temp.delegate = self;
        
        [self reset];
        feedParser = temp;
        delegate = parserDelegate;
        [feedParser setShouldProcessNamespaces:YES];
        [feedParser parse];
        feedParser = nil;
        return;
    }
    
    [self parsingFailedWithErrorCode:MWErrorCodeFeedParsingError andDescription:@"Feed not a valid XML document"];
}
@end
#endif

