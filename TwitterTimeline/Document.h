//
//  Document.h
//  TwitterTimeline
//
//  Created by Martin Dufort on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <CloudKit/CloudKit.h>


@interface Tweet : CKObject
@property(nonatomic,copy) NSURL* imageUrl;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* message;
@end

@interface Timeline : CKObject
@property(nonatomic,retain) CKArrayCollection* tweets;
@end
