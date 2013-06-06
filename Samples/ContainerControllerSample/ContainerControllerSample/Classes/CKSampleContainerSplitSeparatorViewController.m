//
//  CKSampleContainerSplitSeparatorViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerSplitSeparatorViewController.h"

@interface CKSampleContainerSplitSeparatorViewController ()

@end

@implementation CKSampleContainerSplitSeparatorViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIButton* bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.name = @"ShowHideLeft";
    
    //This could have been made in stylesheets
    [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoBack"] forState:UIControlStateNormal];
    [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoForward"] forState:UIControlStateSelected];
    [bu sizeToFit];
    
    bu.frame = CGRectMake(self.view.width / 2 - bu.width / 2,10,bu.width,bu.height);
    bu.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:bu];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    __unsafe_unretained CKSampleContainerSplitSeparatorViewController* bself = self;
    
    UIButton* ShowHideLeft = [self.view viewWithKeyPath:@"ShowHideLeft"];
    ShowHideLeft.selected = YES;
    
    [self beginBindingsContextByRemovingPreviousBindings];
    [ShowHideLeft bindEvent:UIControlEventTouchUpInside withBlock:^(){
        ShowHideLeft.selected = !ShowHideLeft.selected;
        
        if(bself.didSelectShowHide){
            bself.didSelectShowHide(ShowHideLeft.selected);
        }
    }];
    
    [self endBindingsContext];

}


@end
