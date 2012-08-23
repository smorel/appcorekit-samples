//
//  Document.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "Document.h"

//While serializing CKObjects hierarchy in CKStore, each object gets a unique UUID.
//We have to set a specific UUID for our root object to be able to load it later.
static NSString* kUserSettingsUUID = @"00000000-0000-0000-0000-000000000010";

@implementation UserSettings
@synthesize name, forname, phoneNumber, birthDate, numberOfChildren,title,phoneNumberConfirmation;

+ (id)newSharedInstance{
    UserSettings* shared = (UserSettings*)[CKObject loadObjectWithUniqueId:kUserSettingsUUID];
    if(!shared){
        shared = [[UserSettings alloc]init];
        shared.uniqueId = kUserSettingsUUID;
    }
    return shared;
}

- (void)save{
    //By setting recursive to YES here, we ensure we'll save the whole UserSettings objects graph.
    //In this particular case, we do not have  objects or collections properties in ou model ...
    [self saveObjectToDomainNamed:@"CKStoreSampleDomain" recursive:YES];
}

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
    
    __block UserSettings* bself = self;
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

@end
