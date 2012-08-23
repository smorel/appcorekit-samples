//
//  FeedSourceFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "FeedSourceFactory.h"

@implementation FeedSourceFactory

+ (CKFeedSource*)feedSourceForModels{
    CKWebSource* webSource = [CKWebSource webSource];
    webSource.requestBlock = ^(NSRange range){
        NSURL* tweetsAPIUrl = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/public_timeline.json"];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.length],@"count",@"true",@"include_entities", nil];
        
        CKWebRequest* request = [CKWebRequest requestForObjectsWithUrl:tweetsAPIUrl
                                                                params:(NSDictionary*)params
                                                                  body:nil
                                              mappingContextIdentifier:@"$Model"
                                                      transformRawData:nil
                                                            completion:nil
                                                                 error:nil];
        return request;
        
    };
    return webSource;
}

@end
