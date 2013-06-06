//
//  CKSampleContainerTabViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerTabViewController.h"
#import "CKSampleContainerSplitViewController.h"
#import "CKSampleContainerSegmentedViewController.h"
#import "CKSampleContainerBreadCrumbViewController.h"
#import "CKSampleContainerCustomContainerViewController.h"

@implementation CKSampleContainerTabViewController

- (void)postInit{
    [super postInit];
    
    self.viewControllers = @[
        [CKSampleContainerSplitViewController controller],
        [CKSampleContainerSegmentedViewController controller],
        [CKSampleContainerBreadCrumbViewController controller],
        [CKSampleContainerCustomContainerViewController controller]
    ];
}

@end
