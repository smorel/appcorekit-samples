//
//  CKSampleStoreUserObjectViewController.m
//  CKStoreSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleStoreUserObjectViewController.h"

@interface CKSampleStoreUserObjectViewController ()
@property(nonatomic,retain) CKSampleStoreUserObjectModel* userObject;
@end

@implementation CKSampleStoreUserObjectViewController

- (id)initWithUserObject:(CKSampleStoreUserObjectModel*)theUserObject{
    self = [super init];
    self.userObject = theUserObject;
    [self setup];
    return self;
}

- (void)setup{
    CKSection* section1 = [CKSection sectionWithObject:self.userObject
                                                    properties:@[ @"text" ]
                                                   headerTitle:nil];
    
    [self addSections:@[section1] animated:NO];
}

@end
