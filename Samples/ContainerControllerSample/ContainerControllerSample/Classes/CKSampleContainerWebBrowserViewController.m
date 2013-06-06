//
//  CKSampleContainerWebBrowserViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerWebBrowserViewController.h"


@implementation CKSampleContainerWebBrowserViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.autoManageNavigationAndToolBar = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

@end
