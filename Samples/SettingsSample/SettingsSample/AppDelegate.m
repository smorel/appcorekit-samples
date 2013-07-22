//
//  AppDelegate.m
//  SettingsForm
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "CKSampleSettingsViewController.h"
#import "CKSampleSettingsModel.h"
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
    
    
    
   [[CKStyleManager defaultManager]loadContentOfFileNamed:@"Stylesheet"];
    
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
    CKSampleSettingsViewController* viewController = [[CKSampleSettingsViewController alloc]initWithSettings:[CKSampleSettingsModel sharedInstance]];
    
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
