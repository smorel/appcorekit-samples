//
//  AppDelegate.m
//  Map
//
//  Created by Martin Dufort on 12-08-20.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "FlowManager.h"
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
   [CKMappingContext loadContentOfFileNamed:@"Api"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
   return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    [[FlowManager sharedInstance] startInWindow:self.window];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
