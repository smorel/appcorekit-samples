//
//  AppDelegate.m
//  ContainerControllerSample
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
    return @"E7geOxQIIPBhrPVRmLG/skbm4CsmLOwl2da9guNCKB+yZVQ4iHo4O8+8Q0gC89HwiYsWS7wsSKYHyICylxOnmnSqSiwSMT7KRPK5mWlYjciRYwVTNRnWEo1MjeXIOG9dXw5Dn9pNjBOsyF+hr1TUnUbnYO8YTm7p6ldqoxEE5WmmKJ64AK0O0SudFyZyF6TYO9XKzARvGiX2JAPEnyktVz//yPlGhx2YqilkmF4elcboBbnnyYCB5Y8/VvuplpZnABgcOe6OtTQT7zDMq5sh97Hp/3e4JR2a01L5kJNNfLiWZMqRJFCen4AFwqBkJQqzC4GaL1jgS5lhAQUUYLNqjA==";
}

@end


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
    
   return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ViewControllerFactory mainViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
