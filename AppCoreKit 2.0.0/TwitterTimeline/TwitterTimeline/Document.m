//
//  Document.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "Document.h"

@implementation Tweet
@synthesize imageUrl,name,message,identifier;
@end

@implementation Timeline
@synthesize tweets;
@end
