//
//  CKStylesheetSampleButtonViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleButtonViewController.h"

@interface CKStylesheetSampleButtonViewController ()

@end

@implementation CKStylesheetSampleButtonViewController

+ (NSString*)stylesheetFileName{
    return [[self class]description];
}

+ (NSString*)title{
    return _(@"UIButton");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self beginBindingsContextByRemovingPreviousBindings];
    
    [self setupSegmentedControl];
    
    [self endBindingsContext];
}

- (void)setupSegmentedControl{
    
    UISegmentedControl* control = [self.view viewWithKeyPath:@"ButtonStateSelector"];
    [control removeAllSegments];
    
    [control insertSegmentWithTitle:_(@"Highlighted") atIndex:0 animated:NO];
    [control insertSegmentWithTitle:_(@"Disabled")    atIndex:1 animated:NO];
    [control insertSegmentWithTitle:_(@"Selected")    atIndex:2 animated:NO];
    [control insertSegmentWithTitle:_(@"Normal")      atIndex:3 animated:NO];
    
    UIButton* button = [self.view viewWithKeyPath:@"BUTTON"];
    
    [control bindEvent:UIControlEventValueChanged withBlock:^{
        switch(control.selectedSegmentIndex){
            case 0:{
                button.highlighted = YES;
                button.enabled = YES;
                button.selected = NO;
                break;
            }
            case 1:{
                button.highlighted = NO;
                button.enabled = NO;
                button.selected = NO;
                break;
            }
            case 2:{
                button.highlighted = NO;
                button.enabled = YES;
                button.selected = YES;
                break;
            }
            case 3:{
                button.highlighted = NO;
                button.enabled = YES;
                button.selected = NO;
                break;
            }
        }
    }];
    
    [button bind:@"selected" withBlock:^(id value) {
        if(button.selected) { control.selectedSegmentIndex = 2; }
        else if(!button.highlighted && button.enabled && !button.selected) { control.selectedSegmentIndex = 3; }
    }];
    
    [button bind:@"enabled" withBlock:^(id value) {
        if(!button.enabled) { control.selectedSegmentIndex = 1; }
        else if(!button.highlighted && button.enabled && !button.selected) { control.selectedSegmentIndex = 3; }
    }];
    
    [button bind:@"highlighted" withBlock:^(id value) {
        if(button.highlighted) { control.selectedSegmentIndex = 0; }
        else if(!button.highlighted && button.enabled && !button.selected) { control.selectedSegmentIndex = 3; }
        else if(!button.highlighted && button.enabled &&  button.selected) { control.selectedSegmentIndex = 2; }
    }];
}

@end
