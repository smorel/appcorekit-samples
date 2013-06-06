//
//  CKSampleStoreUserSettingsModel.m
//  CKStoreSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleStoreUserSettingsModel.h"


//While serializing CKObjects hierarchy in CKStore, each object gets a unique UUID.
//We have to set a specific UUID for our root object to be able to load it later.
static NSString* kUserSettingsUUID = @"00000000-0000-0000-0000-000000000010";


@implementation CKSampleStoreUserSettingsModel

#pragma mark Initialization

//This method is called when executing [CKSampleStoreUserSettingsModel sharedInstance]
//This allow to customize the way your shared instance must be allocated/initialized
+ (id)newSharedInstance{
    CKSampleStoreUserSettingsModel* shared = (CKSampleStoreUserSettingsModel*)[CKObject loadObjectWithUniqueId:kUserSettingsUUID];
    if(!shared){
        shared = [[CKSampleStoreUserSettingsModel alloc]init];
        shared.uniqueId = kUserSettingsUUID;
    }
    return shared;
}


#pragma mark Serialization

//By setting recursive to YES here, we ensure we'll save the whole CKSampleStoreUserSettingsModel objects graph.
- (void)save{
    [self saveObjectToDomainNamed:@"CKSampleStoreUserSettingsModelDomain" recursive:YES];
}

#pragma mark Properties Extended Attributes

//ExtendedAttributes is a non formal dynamic protocol based on property name.
//The AppCoreKit framework uses runtime to generate selector to access extended attributes on specific properties when needed.
//In this example, the properties will get represented by AppCoreKit specific table view cell that uses those extended attributes to customize their behaviour.

- (void)titleExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    //enumDescriptor defines a dictionary a string to value representing the possible choices for the property title.
    //It is also used for serializing/deserializing objects in cascadingTrees (Stylesheets, Mappings, ...) and CKStore (Core data generic model).
    //The string that are visually represented as options in the table view are localized.
    //We customize those strings in the .string file of the application.
    
    attributes.enumDescriptor = CKEnumDefinition(@"CKUserTitle",
                                                 CKGenderMister,
                                                 CKGenderMiss,
                                                 CKGenderMisses);
    
    //AppCoreKit provides a validation system for objects based on extended properties.
    //By implementing the validationPredicate in the extended attributes, calling [myUserSettings validate] returns a validation results object wich gives access to the invalid properties of the object.
    
    attributes.validationPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ([evaluatedObject intValue] >= CKGenderMister) && ([evaluatedObject intValue] <= CKGenderMisses);
    }];
    
}

- (void)phoneNumberExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    //Phone number is a string. It will be represented by a table view cell wich input is optionally customized by implementing the following block.
    
    attributes.textInputFormatterBlock = ^(id textInputView,NSRange range, NSString* replacementString){
        return [NSString formatAsPhoneNumberUsingTextField:textInputView range:range replacementString:replacementString];
    };
}

- (void)phoneNumberConfirmationExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    //phoneNumberConfirmation number is a string. It will be represented by a table view cell wich input is optionally customized by implementing the following block.
    
    attributes.textInputFormatterBlock = ^(id textInputView,NSRange range, NSString* replacementString){
        return [NSString formatAsPhoneNumberUsingTextField:textInputView range:range replacementString:replacementString];
    };
    
    __block CKSampleStoreUserSettingsModel* bself = self;
    attributes.validationPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject && [evaluatedObject isEqualToString:[bself phoneNumber]];
    }];
}

- (void)nameExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    attributes.validationPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject && ([evaluatedObject length] > 0);
    }];
}

- (void)fornameExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    attributes.validationPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject && ([evaluatedObject length] > 0);
    }];
}

- (void)birthDateExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    attributes.maximumDate = [NSDate date];
    attributes.dateFormat = @"dd MMMM YYYY";
    attributes.validationPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject != nil;
    }];
}

- (void)numberOfChildrenExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    attributes.placeholderValue = [NSNumber numberWithInt:0];
}

- (void)userObjectExtendedAttributes:(CKPropertyExtendedAttributes*)attributes{
    NSMutableDictionary* dico = [NSMutableDictionary dictionary];
    for(CKSampleStoreUserObjectModel* obj in [self.userObjects allObjects]){
        if(obj.text){
            [dico setValue:obj forKey:obj.text];
        }
    }
    attributes.valuesAndLabels = dico;
}


- (BOOL)hasValidUserObjects{
    for(CKSampleStoreUserObjectModel* object in [self userObjects]){
        if([[object text]length] > 0){
            return YES;
        }
    }
    return NO;
}


@end
