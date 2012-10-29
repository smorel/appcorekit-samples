//
//  AppDelegate.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllers.h"
#import "FeedSources.h"


@implementation CKLicense(YourAppName)

+ (NSString*)licenseKey{
    //Return your license key here.
    return @"__APPCOREKIT_LICENSE_KEY__";
}

@end

@implementation AppDelegate

@synthesize window = _window;

- (id)init{
    self = [super init];
    [[CKStyleManager defaultManager]loadContentOfFileNamed:@"TwitterTimeline"];
    [CKMappingContext loadContentOfFileNamed:@"TwitterTimeline"];
    //[[CKMockManager defaultManager]loadContentOfFileNamed:@"TwitterTimeline"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
    [[CKConfiguration sharedInstance]setUsingARC:YES];
    
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Timeline* timeline = [Timeline sharedInstance];
    timeline.tweets.feedSource = [FeedSources feedSourceForTweets];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewControllers viewControllerForTimeline:timeline]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
