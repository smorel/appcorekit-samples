//
//  CKSampleSettingsModel.h
//  SettingsSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

//This document model inherits CKUserDefaults
//CKUserDefaults uses runtime to automatically synchronize any of its property changes to the UserDefaults automatically.

typedef enum CKUserTitle{
    CKGenderMister = 1,
    CKGenderMiss   = 2,
    CKGenderMisses = 3
}CKUserTitle;

@interface CKSampleSettingsModel : CKUserDefaults

@property(nonatomic,copy)   NSString* name;
@property(nonatomic,copy)   NSString* forname;
@property(nonatomic,copy)   NSString* phoneNumber;
@property(nonatomic,copy)   NSString* phoneNumberConfirmation;
@property(nonatomic,copy)   NSDate*   birthDate;
@property(nonatomic,assign) NSInteger numberOfChildren;
@property(nonatomic,assign) CKUserTitle title;

@end
