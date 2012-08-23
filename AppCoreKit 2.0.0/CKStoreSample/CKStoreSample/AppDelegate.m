//
//  AppDelegate.m
//  SettingsForm
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerFactory.h"
#import "Document.h"
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
    CKFormTableViewController* form = [ViewControllerFactory viewControllerForSettings:[UserSettings sharedInstance]];
    form.title = _(@"kSettingsViewControllerTitle");
    
    //Here we setup a validation button in the navigation controller that will validate the form and pop an alert when everything is OK.
    form.rightButton = [UIBarButtonItem barButtonItemWithTitle:_(@"kValidateButton") style:UIBarButtonItemStyleBordered block:^(){
        CKObjectValidationResults* validationResults = [[UserSettings sharedInstance]validate];
        if(![validationResults isValid]){
            NSMutableString* invalidProperties = [NSMutableString string];
            for(CKProperty* property in validationResults.invalidProperties){
                [invalidProperties appendFormat:@"\n%@",_(property.keyPath)];
            }
            
            NSString* message = [NSString stringWithFormat:_(@"kAlertView_invalidPropertiesMessage"),invalidProperties];
            CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertView_ValidatedTitle") message:message];
            [alert addButtonWithTitle:_(@"kOk") action:nil];
            [alert show];
        }else{
            CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertView_ValidatedTitle") message:_(@"kAlertView_validateMessage")];
            [alert addButtonWithTitle:_(@"kOk") action:^{
                //Do something here when user tap the Ok button
            }];
            [alert show];
        }
    }];
    
    self.window = [UIWindow  viewWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UINavigationController navigationControllerWithRootViewController:form];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[UserSettings sharedInstance]save];
}

@end
