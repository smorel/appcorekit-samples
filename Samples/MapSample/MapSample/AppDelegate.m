//
//  AppDelegate.m
//  Map
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleMapViewController.h"


@implementation AppDelegate

@synthesize window = _window;

- (id)init{
   self = [super init];
   [CKMappingContext loadContentOfFileNamed:@"CKSampleMapDataSources"];
    
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
    UINavigationController* navigationController = [UINavigationController navigationControllerWithRootViewController:[CKSampleMapViewController controller]];
    
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
