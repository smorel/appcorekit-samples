//
//  Document.h
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

//This document model inherits CKUserDefaults
//CKUserDefaults uses runtime to automatically synchronize any of its property changes to the UserDefaults automatically.

typedef enum CKUserTitle{
    CKGenderMister = 1,
    CKGenderMiss   = 2,
    CKGenderMisses = 3
}CKUserTitle;

@interface UserSettings : CKUserDefaults
@property(nonatomic,copy)   NSString* name;
@property(nonatomic,copy)   NSString* forname;
@property(nonatomic,copy)   NSString* phoneNumber;
@property(nonatomic,copy)   NSString* phoneNumberConfirmation;
@property(nonatomic,copy)   NSDate*   birthDate;
@property(nonatomic,assign) NSInteger numberOfChildren;
@property(nonatomic,assign) CKUserTitle title;
@end
