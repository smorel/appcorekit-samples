//
//  CKStylesheetSampleUISliderViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-08-30.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleUISliderViewController.h"

@interface CKStylesheetSampleUISliderViewController ()

@end

@implementation CKStylesheetSampleUISliderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UISlider* tintSlider = [self.view viewWithKeyPath:@"TINT_SLIDER"];
    UISlider* imageSlider = [self.view viewWithKeyPath:@"IMAGES_SLIDER"];
    
    UILabel* valueLabel = [self.view viewWithKeyPath:@"VALUE_LABEL"];
    
    [self beginBindingsContextByRemovingPreviousBindings];
    
    [tintSlider bindEvent:UIControlEventValueChanged withBlock:^{
        if(imageSlider.value != tintSlider.value){
            imageSlider.value = tintSlider.value;
        }
        valueLabel.text = [NSString stringWithFormat:@"%f",tintSlider.value];
    }];
    
    [imageSlider bindEvent:UIControlEventValueChanged withBlock:^{
        if(imageSlider.value != tintSlider.value){
            tintSlider.value = imageSlider.value;
        }
        valueLabel.text = [NSString stringWithFormat:@"%f",imageSlider.value];
    }];
    
    void(^sliderDidEndEditing)(NSString* sliderName) = ^(NSString* sliderName){
        CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"Slider did end editing") message:sliderName];
        [alert addButtonWithTitle:_(@"Dismiss") action:nil];
        [alert show];
    };
    
    [tintSlider bindEvent:UIControlEventTouchUpInside withBlock:^{
        sliderDidEndEditing(tintSlider.name);
    }];
    
    [imageSlider bindEvent:UIControlEventTouchUpInside withBlock:^{
        sliderDidEndEditing(imageSlider.name);
    }];
    
    [self endBindingsContext];
}

@end
