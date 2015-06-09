//
//  CKSampleStoreSettingsViewController.h
//  CKStoreSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleStoreUserSettingsModel.h"

@interface CKSampleStoreSettingsViewController : CKTableViewController

- (id)initWithSettings:(CKSampleStoreUserSettingsModel*)settings;

@end
