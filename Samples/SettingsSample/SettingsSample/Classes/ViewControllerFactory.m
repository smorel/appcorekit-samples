//
//  ViewControllerFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllerFactory.h"

@implementation ViewControllerFactory

+ (CKFormTableViewController*)viewControllerForSettings:(UserSettings*)settings{
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"Settings"];
    form.supportedInterfaceOrientations = CKInterfaceOrientationPortrait;
    
    //AppCoreKit provides a lot of helpers to create section or cell controller using runtime.
    //Those helpers choose the right table view cell controller implementation and automatically setup a 2 way connection betwwen the object's property in memory and the controls editing this property.
    //Both stay in sync at any time wether the user edit the value or if the value is set programatically.
    //Each of these cell controller can be targeted specifically in stylesheet for precise customization based on the cell controller value's keypath as in the background,
    //   the cell controllers value are CKProperty instances initialized with object(settings) keyPath(the property name)
    //cf. (ViewControllerForSettings.style)
    
    CKFormSection* section1 = [CKFormSection sectionWithObject:settings 
                                                    properties:[NSArray arrayWithObjects:@"title",@"name",@"forname",@"birthDate",nil] 
                                                   headerTitle:_(@"kIdentification")];
    CKFormSection* section2 = [CKFormSection sectionWithObject:settings 
                                                    properties:[NSArray arrayWithObjects:@"phoneNumber",@"phoneNumberConfirmation",nil] 
                                                   headerTitle:_(@"kContact")];
    CKFormSection* section3 = [CKFormSection sectionWithObject:settings 
                                                    properties:[NSArray arrayWithObjects:@"numberOfChildren",nil] 
                                                   headerTitle:_(@"kFamilly")];
    
    
    [form addSections:[NSArray arrayWithObjects:section1,section2,section3,nil]];
    return form;
}

@end
