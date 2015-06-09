//
//  CKSampleTwitterTimelineViewController.m
//  TwitterTimeline
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleTwitterTimelineViewController.h"

@interface CKSampleTwitterTimelineViewController ()
@property(nonatomic,retain) CKSampleTwitterTimelineModel* timeline;
@end

@implementation CKSampleTwitterTimelineViewController


- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)theTimeline{
    self = [super init];
    self.timeline = theTimeline;
    [self setup];
    return self;
}

- (void)setup{
    self.title = _(@"kTimelineTitle");
    
    __unsafe_unretained CKSampleTwitterTimelineViewController* bself = self;
    
    //Setup the factory allowing to create cell controller when tweet models gets inserted into self.timeline.tweets collection asynchronously
    CKReusableViewControllerFactory* tweetsFactory = [CKReusableViewControllerFactory factory];
    [tweetsFactory registerFactoryForObjectOfClass:[CKSampleTwitterTweetModel class] factory:^CKReusableViewController *(id object, NSIndexPath *indexPath) {
        CKSampleTwitterTweetModel* tweet = (CKSampleTwitterTweetModel*)object;
        return [bself cellControllerForTweet:tweet];
    }];
    
    //Setup the section binded to the self.timeline.tweets collection
    CKCollectionSection* section = [CKCollectionSection sectionWithCollection:self.timeline.tweets factory:tweetsFactory];
    CKCollectionStatusViewController* status = [CKCollectionStatusViewController controllerWithCollection:self.timeline.tweets];
    [section addCollectionFooterController:status animated:NO];
    
    [self addSections:@[section] animated:NO];
}


- (CKReusableViewController*)cellControllerForTweet:(CKSampleTwitterTweetModel*)tweet{
    //Setup the cell controller to display a tweet model
    CKStandardContentViewController* cellController =  [CKStandardContentViewController controllerWithTitle:tweet.name
                                                                                           subtitle:tweet.message
                                                                                       defaultImageName:@"default_avatar"
                                                                                           imageURL:tweet.imageUrl
                                                                                             action:nil];
    
    return cellController;
}

@end
