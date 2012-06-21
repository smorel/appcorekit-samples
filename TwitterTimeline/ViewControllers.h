//
//  ViewControllers.h
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "Document.h"

@interface ViewControllers : NSObject

+ (CKViewController*)viewControllerForTimeline:(Timeline*)timeline;

@end
