//
//  CKSampleMapDataSources.h
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleMapModel.h"

@interface CKSampleMapDataSources : NSObject

+ (void)reverseGeolocalizationUsingAddress:(NSString*)address completionBlock:(void(^)(CLLocationCoordinate2D coordinates))completionBlock;
+ (CKFeedSource*)feedSourceForModels;

@end