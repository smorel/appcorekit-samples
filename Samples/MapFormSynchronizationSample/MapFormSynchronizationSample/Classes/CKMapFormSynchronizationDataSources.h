//
//  CKMapFormSynchronizationDataSources.h
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppCoreKit/AppCoreKit.h>

@interface CKMapFormSynchronizationDataSources : NSObject

+ (CKFeedSource*)sourceForFoursquareVenuesNear:(NSString*)near section:(NSString*)section;

@end
