//
//  CKSampleStoreUserSettingsModel.h
//  CKStoreSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleStoreUserObjectModel.h"

//This document will get saved in Core Data using the CKStore
//The CKStore is a generic relational key/value model able to serialize/deserialize a graph of objects in core data.
//Storing objects and collections of objects or pointer to objects is automatically managed for you.

typedef enum CKUserTitle{
    CKGenderMister = 1,
    CKGenderMiss   = 2,
    CKGenderMisses = 3
}CKUserTitle;

@interface CKSampleStoreUserSettingsModel : CKObject

@property(nonatomic,copy)   NSString* name;
@property(nonatomic,copy)   NSString* forname;
@property(nonatomic,copy)   NSString* phoneNumber;
@property(nonatomic,copy)   NSString* phoneNumberConfirmation;
@property(nonatomic,copy)   NSDate*   birthDate;
@property(nonatomic,assign) NSInteger numberOfChildren;
@property(nonatomic,assign) CKUserTitle title;
@property(nonatomic,retain) CKArrayCollection* userObjects; //Collection of CKSampleStoreUserObjectModel
@property(nonatomic,retain) CKSampleStoreUserObjectModel* userObject;

- (BOOL)hasValidUserObjects;

//This method will transform the UserSetting instance to a set of CKStore managed objects.
//You should call this method in your AppDelegate willEnterBackground method as core data synchronization is done at this particular moment.
- (void)save;

@end
