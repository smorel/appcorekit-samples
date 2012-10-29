//
//  AppDelegate.m
//  BindingsSample
//
//  Created by Martin Dufort on 12-08-21.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerFactory.h"
#import <AppCoreKit/AppCoreKit.h>


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
    
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:[ViewControllerFactory viewControllerForBindingsSample]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
