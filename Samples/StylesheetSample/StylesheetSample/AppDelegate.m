//
//  AppDelegate.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "CKStylesheetSampleViewController.h"
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
    
    
   [CKMappingContext loadContentOfFileNamed:@"Api"];
    
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
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [CKStylesheetSampleViewController controller];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
