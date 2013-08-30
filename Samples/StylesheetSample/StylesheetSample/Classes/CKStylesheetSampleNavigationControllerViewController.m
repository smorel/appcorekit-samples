//
//  CKStylesheetSampleNavigationControllerViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-08-29.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleNavigationControllerViewController.h"

@interface CKStylesheetSampleNavigationControllerViewController ()

@end

@implementation CKStylesheetSampleNavigationControllerViewController

- (void)postInit{
    [super postInit];
    
    [self setup];
}

- (CKViewController*)sampleViewController{
    __unsafe_unretained CKStylesheetSampleNavigationControllerViewController* bself = self;
    
    CKViewController* controller = [CKViewController controllerWithName:@"Sample"];
    
    
    controller.viewWillAppearBlock = ^(CKViewController* controller, BOOL animated){
        //Set the toolbar items in code as it doesn't work by introspection.
        UIBarButtonItem* t1 = [UIBarButtonItem barButtonItemWithTitle:_(@"T1") style:UIBarButtonItemStyleBordered block:^{
            CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"Toolbar item") message:_(@"T1!")];
            [alert addButtonWithTitle:_(@"Dismiss") action:nil];
            [alert show];
        }];
        t1.name = @"TOOLBAR_BUTTON_1";
        [controller setToolbarItems:@[ t1 ]];
    };

    controller.viewWillAppearEndBlock = ^(CKViewController* controller, BOOL animated){
        __unsafe_unretained CKViewController* bController = controller;
        
        [controller beginBindingsContextByRemovingPreviousBindings];
        
        UIButton* pushButton = [controller.view viewWithKeyPath:@"PUSHBUTTON"];
        [pushButton bindEvent:UIControlEventTouchUpInside  withBlock:^{
            CKViewController* toPush = [bself sampleViewController];
            [bController.navigationController pushViewController:toPush animated:YES];
        }];
        
        [controller.navigationItem.rightBarButtonItem bindEventWithBlock:^{
            CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"Right bar button item") message:_(@"OLE!")];
            [alert addButtonWithTitle:_(@"Dismiss") action:nil];
            [alert show];
        }];
        
        [controller endBindingsContext];
    };
    
    return controller;
}

- (void)setup{
    UINavigationController* nav = [UINavigationController navigationControllerWithRootViewController:[self sampleViewController]];
    [nav setToolbarHidden:NO animated:NO];
    self.viewControllers = @[nav];
}

@end