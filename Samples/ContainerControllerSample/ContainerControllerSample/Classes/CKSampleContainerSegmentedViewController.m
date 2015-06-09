//
//  CKSampleContainerSegmentedViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerSegmentedViewController.h"

@implementation CKSampleContainerSegmentedViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (void)setup{
    self.title = _(@"kSegmentedTitle");
    self.segmentPosition = CKSegmentedViewControllerPositionBottom;
    
    CKViewController* PlaceHolder = [CKViewController controllerWithName:@"PlaceHolder"];
    PlaceHolder.title = @"PlaceHolder";
    
    CKViewController* PlaceHolder2 = [CKViewController controllerWithName:@"PlaceHolder2"];
    PlaceHolder2.title = @"PlaceHolder2";
    
    [self setViewControllers:@[PlaceHolder,PlaceHolder2]];

}

@end
