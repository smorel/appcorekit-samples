//
//  CKSampleSettingsViewController.m
//  SettingsSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleSettingsViewController.h"

@interface CKSampleSettingsViewController()
@property(nonatomic,retain) CKSampleSettingsModel* settings;
@end

@implementation CKSampleSettingsViewController

- (id)initWithSettings:(CKSampleSettingsModel*)theSettings{
    self = [super init];
    self.settings = theSettings;
    [self setup];
    return self;
}

- (void)setup{
    self.title = _(@"kSettingsViewControllerTitle");
    self.supportedInterfaceOrientations = CKInterfaceOrientationPortrait;
    
    //Adds sections
    [self addSections:@[
      [self sectionForIdentification],
      [self sectionForContact],
      [self sectionForFamily]
    ]];
    
    __unsafe_unretained CKSampleSettingsViewController* bSelf = self;
    
    //Here we setup a validation button in the navigation controller that will validate the form and pop an alert when everything is OK.
    
    self.rightButton = [UIBarButtonItem barButtonItemWithTitle:_(@"kValidateButton") style:UIBarButtonItemStyleBordered block:^(){
        CKObjectValidationResults* validationResults = [bSelf.settings validate];
        if(![validationResults isValid]){
            NSMutableString* invalidProperties = [NSMutableString string];
            for(CKProperty* property in validationResults.invalidProperties){
                [invalidProperties appendFormat:@"\n%@",_(property.keyPath)];
            }
            
            NSString* message = [NSString stringWithFormat:_(@"kAlertView_invalidPropertiesMessage"),invalidProperties];
            CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertView_ValidatedTitle") message:message];
            [alert addButtonWithTitle:_(@"kOk") action:nil];
            [alert show];
        }else{
            CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertView_ValidatedTitle") message:_(@"kAlertView_validateMessage")];
            [alert addButtonWithTitle:_(@"kOk") action:^{
                //Do something here when user tap the Ok button
            }];
            [alert show];
        }
    }];
}


/* In the following samples, we uses AppCoreKit high level helpers to create sections with rows that allow to edit/display and stay in sync
   With some of your model's properties.
   These rows uses the extended attributes informal protocol to ask your model for how it should react for some part of the behaviour
   including validating the property value or even for representing the property.
   You can see some example in CKSampleStoreUserSettingsModel.m
 
   Using this extended attributes, the model defines how its properties must be represented by the property cell controllers that are
   provided by AppCoreKit. By this way any time you need to edit/display this property in one or several view controllers,
   the behaviour of validation and represention is provided once by the model and you can use the following helpers
   to simply describe your form.
 */

- (CKFormSectionBase*)sectionForIdentification{
    return [CKFormSection sectionWithObject:self.settings
                                 properties:[NSArray arrayWithObjects:@"title",@"name",@"forname",@"birthDate",nil]
                                headerTitle:_(@"kIdentification")];
}

- (CKFormSectionBase*)sectionForContact{
    return [CKFormSection sectionWithObject:self.settings
                                 properties:[NSArray arrayWithObjects:@"phoneNumber",@"phoneNumberConfirmation",nil]
                                headerTitle:_(@"kContact")];
}

- (CKFormSectionBase*)sectionForFamily{
    return [CKFormSection sectionWithObject:self.settings
                                 properties:[NSArray arrayWithObjects:@"numberOfChildren",nil]
                                headerTitle:_(@"kFamily")];
}

@end
