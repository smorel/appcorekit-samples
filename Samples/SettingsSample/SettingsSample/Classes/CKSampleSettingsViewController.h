//
//  CKSampleSettingsViewController.h
//  SettingsSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleSettingsModel.h"

@interface CKSampleSettingsViewController : CKFormTableViewController

- (id)initWithSettings:(CKSampleSettingsModel*)settings;

@end
