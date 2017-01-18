//
//  CKStylesheetSampleNavigationControllerViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-08-29.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleNavigationControllerViewController.h"

@interface CKSimpleViewController : CKViewController
@end

@implementation CKSimpleViewController

- (void)viewWillAppear:(bool)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem* t1 = [UIBarButtonItem barButtonItemWithTitle:_(@"T1") style:UIBarButtonItemStyleBordered block:^{
        CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"Toolbar item") message:_(@"T1!")];
        [alert addButtonWithTitle:_(@"Dismiss") action:nil];
        [alert show];
    }];
    t1.name = @"TOOLBAR_BUTTON_1";
    [self setToolbarItems:@[ t1 ]];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    __unsafe_unretained UIViewController* bself = self;
    [self beginBindingsContextByRemovingPreviousBindings];
    
    UIButton* pushButton = [self.view viewWithKeyPath:@"PUSHBUTTON"];
    [pushButton bindEvent:UIControlEventTouchUpInside  withBlock:^{
        CKViewController* toPush = [CKSimpleViewController controller];
        [bself.navigationController pushViewController:toPush animated:YES];
    }];
    
    //FIXME : doesn't gets called!
    [self.navigationItem.rightBarButtonItem bindEventWithBlock:^{
        CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"Right bar button item") message:_(@"OLE!")];
        [alert addButtonWithTitle:_(@"Dismiss") action:nil];
        [alert show];
    }];
    
    [self endBindingsContext];

}

@end

@interface CKStylesheetSampleNavigationControllerViewController ()

@end

@implementation CKStylesheetSampleNavigationControllerViewController

- (void)postInit{
    [super postInit];
    
    [self setup];
}


- (void)setup{
    UINavigationController* nav = [[UINavigationController alloc]init];
    self.viewControllers = @[nav];
    [nav setViewControllers:@[[CKSimpleViewController controller]]];
}

@end
