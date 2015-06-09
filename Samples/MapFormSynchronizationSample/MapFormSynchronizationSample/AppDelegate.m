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
#import <ResourceManager/ResourceManager.h>


@implementation AppDelegate

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
    CKMapFormSynchronizationViewController* viewController = [[CKMapFormSynchronizationViewController alloc]initWithStyle:UITableViewStylePlain];
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:viewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
