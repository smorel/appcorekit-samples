//
//  CKSampleLayoutInstagramDataSources.h
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleLayoutInstagramModel.h"

@interface CKSampleLayoutInstagramDataSources : NSObject

+ (void)fetchRandomUserInModel:(CKSampleLayoutInstagramModel*)model completion:(void(^)())completion;

@end
