//
//  FeedSourceFactory.h
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "Document.h"

@interface FeedSourceFactory : NSObject

+ (CKFeedSource*)feedSourceForModels;

@end
