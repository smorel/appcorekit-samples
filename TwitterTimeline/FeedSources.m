//
//  FeedSources.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "FeedSources.h"

@implementation FeedSources

+ (CKFeedSource*)feedSourceForTweets{
    CKWebSource* webSource = [[[CKWebSource alloc]init]autorelease];
    webSource.requestBlock = ^(NSRange range){
        NSURL* tweetsAPIUrl = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/public_timeline.json"];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.length],@"count",@"true",@"include_entities", nil];
        
        CKWebRequest* request = [CKWebRequest requestForObjectsWithUrl:tweetsAPIUrl
                                                                params:(NSDictionary*)params
                                                                  body:nil
                                              mappingContextIdentifier:@"$Tweet"
                                                      transformRawData:^(id value){ return (NSArray*)value; }
                                                            completion:^(NSArray* objects){} 
                                                                 error:^(id value, NSHTTPURLResponse* response, NSError* error){}];
        return request;
                                 
    };
    return webSource;
}

@end
