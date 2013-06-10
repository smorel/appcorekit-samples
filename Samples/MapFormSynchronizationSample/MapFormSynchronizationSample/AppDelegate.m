//
//  AppDelegate.m
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "CKMapFormSynchronizationViewController.h"


@implementation AppDelegate

- (id)init{
   self = [super init];
   [CKMappingContext loadContentOfFileNamed:@"CKMapFormSynchronizationDataSources"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
#ifdef __has_feature(objc_arc)
    [[CKConfiguration sharedInstance]setUsingARC:YES];
#endif

   return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CKMapFormSynchronizationViewController* viewController = [[CKMapFormSynchronizationViewController alloc]init];
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:viewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
