//
//  CKSampleLayoutInstagramModel.h
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKSampleLayoutInstagramModel : CKObject
@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,assign) NSInteger numberOfPhotos;
@property(nonatomic,assign) NSInteger numberOfFollowers;
@property(nonatomic,assign) NSInteger numberOfFollowing;
@property(nonatomic,retain) NSString* presentationText;
@property(nonatomic,retain) NSString* detailText;
@property(nonatomic,retain) NSURL* detailURL;
@end
