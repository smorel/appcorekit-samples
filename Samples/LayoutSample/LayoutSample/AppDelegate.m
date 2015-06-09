//
//  AppDelegate.m
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "CKSampleLayoutInstagramViewController.h"
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
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController: [[CKSampleLayoutInstagramViewController alloc]initWithStyle:UITableViewStylePlain]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
