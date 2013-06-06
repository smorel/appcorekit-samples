//
//  AppDelegate.m
//  SettingsForm
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "CKSampleStoreSettingsViewController.h"


@implementation AppDelegate

@synthesize window = _window;

- (id)init{
    self = [super init];
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
    CKSampleStoreUserSettingsModel* settings = [CKSampleStoreUserSettingsModel sharedInstance];
    CKSampleStoreSettingsViewController* viewController = [[CKSampleStoreSettingsViewController alloc]initWithSettings:settings];
    
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[CKSampleStoreUserSettingsModel sharedInstance]save];
}

@end
