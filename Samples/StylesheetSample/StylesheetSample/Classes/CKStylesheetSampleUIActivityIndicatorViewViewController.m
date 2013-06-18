//
//  CKStylesheetSampleUIActivityIndicatorViewViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-18.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleUIActivityIndicatorViewViewController.h"

@interface CKStylesheetSampleUIActivityIndicatorViewViewController ()

@end

@implementation CKStylesheetSampleUIActivityIndicatorViewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIActivityIndicatorView* activityIndicator = [self.view viewWithKeyPath:@"ACTIVITYINDICATOR"];
    [activityIndicator startAnimating];
    
    UIButton* button = [self.view viewWithKeyPath:@"STARTSTOPBUTTON"];
    button.selected = !activityIndicator.isAnimating;
    
    [self beginBindingsContextByRemovingPreviousBindings];
    
    [button bindEvent:UIControlEventTouchUpInside withBlock:^{
        if(activityIndicator.isAnimating){
            [activityIndicator stopAnimating];
        }else{
            [activityIndicator startAnimating];
        }
        button.selected = !activityIndicator.isAnimating;
    }];
    
    [self endBindingsContext];
}

@end
