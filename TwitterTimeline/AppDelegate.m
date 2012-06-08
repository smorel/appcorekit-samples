//
//  AppDelegate.m
//  TwitterTimeline
//
//  Created by Martin Dufort on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllers.h"
#import "FeedSources.h"


@implementation AppDelegate

@synthesize window = _window;

- (id)init{
    self = [super init];
    [[CKStyleManager defaultManager]loadContentOfFileNamed:@"TwitterTimeline"];
    [CKMappingContext loadContentOfFileNamed:@"TwitterTimeline"];
    [[CKMockManager defaultManager]loadContentOfFileNamed:@"TwitterTimeline"];
    return self;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Timeline* timeline = [Timeline sharedInstance];
    timeline.tweets.feedSource = [FeedSources feedSourceForTweets];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = [[[UINavigationController alloc]initWithRootViewController:[ViewControllers viewControllerForTimeline:timeline]]autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
