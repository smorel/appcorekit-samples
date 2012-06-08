//
//  FeedSources.h
//  TwitterTimeline
//
//  Created by Martin Dufort on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <CloudKit/CloudKit.h>

@interface FeedSources : NSObject

+ (CKFeedSource*)feedSourceForTweets;

@end
