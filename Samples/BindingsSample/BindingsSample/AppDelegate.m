//
//  AppDelegate.m
//  BindingsSample
//
//  Created by Martin Dufort on 12-08-21.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "CKSampleBindingsViewController.h"
#import <ResourceManager/ResourceManager.h>

@implementation AppDelegate

@synthesize window = _window;

- (id)init{
   self = [super init];
    
#if TARGET_IPHONE_SIMULATOR
    
    NSString* projectPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SRC_ROOT"];
    RMBundleResourceRepository* localRepository = [[RMBundleResourceRepository alloc]initWithPath:projectPath];
    localRepository.pullingTimeInterval = 1;
    
    RMResourceManager* resourceManager = [[RMResourceManager alloc]initWithRepositories:@[localRepository]];
    
    [RMResourceManager setSharedManager:resourceManager];
#else
#endif
    
    
    
    
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
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    
    CKSampleBindingsViewController* viewController = [CKSampleBindingsViewController controller];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
