//
//  CKStylesheetSampleLabelViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleLabelViewController.h"

@interface CKStylesheetSampleLabelViewController ()

@end

@implementation CKStylesheetSampleLabelViewController

+ (NSString*)stylesheetFileName{
    return [[self class]description];
}

+ (NSString*)title{
    return _(@"UILabel");
}

@end
