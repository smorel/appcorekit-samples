//
//  FeedSources.h
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface FeedSources : NSObject

+ (CKFeedSource*)feedSourceForTweets;

@end
