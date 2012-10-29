//
//  ViewControllerFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllerFactory.h"

@implementation ViewControllerFactory

+ (CKFormTableViewController*)viewControllerForUserObject:(UserObject*)object{
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"UserObject"];
    
    CKFormSection* section1 = [CKFormSection sectionWithObject:object 
                                                    properties:[NSArray arrayWithObjects:@"text",nil] headerTitle:nil];
    
    [form addSections:[NSArray arrayWithObjects:section1,nil]];
    
    return form;
}

+ (BOOL)hasValidObjects:(UserSettings*)settings{
    for(UserObject* object in [[settings userObjects]allObjects]){
        if([[object text]length] > 0){
            return YES;
        }
    }
    return NO;
}

+ (void)updatePropertyCell:(CKTableViewCellController*)controller usingSettings:(UserSettings*)settings{
    BOOL bo = [self hasValidObjects:settings];
    
    //Updates selectUserObject detailText when number of objects in userObjects changes.
    controller.accessoryType = bo ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    controller.flags = bo ? CKItemViewFlagSelectable : CKItemViewFlagNone;
    controller.selectionStyle = bo ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    
    NSString* text = ([settings.userObject text] && [[settings.userObject text]length] > 0)? [settings.userObject text] : _(@"userObject_Placeholder");
    controller.detailText = bo ? text : _(@"kNoUserObjects");
}

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
    
    
    //The following part will manage insertion/deletion of UserObject instance in userObjects collection of setting.
    //This demonstrates that 2 side communication is automatic between the collection and the for section it is binded to.
    
    
    //Setup the cell controller factory for UserObject
    CKCollectionCellControllerFactory* userObjectCellFactory = [CKCollectionCellControllerFactory factory];
    [userObjectCellFactory addItemForObjectOfClass:[UserObject class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        
        NSString* text = ([object text] && [[object text]length] > 0)? [object text] : _(@"kEmptyText");
        
        //Creates a simple cell controller pushing an editing view controller
        CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:text action:^(CKTableViewCellController *controller) {
            CKFormTableViewController* edition = [self viewControllerForUserObject:(UserObject*)object];
            [controller.containerController.navigationController pushViewController:edition animated:YES];
        }];
        cellController.name = @"UserObjectCell"; //For reuse and stylesheets
        cellController.flags = CKItemViewFlagRemovable | CKItemViewFlagSelectable;
        
        //Binds on object text to update the cell controller text
        __block CKTableViewCellController* bCellController = cellController;
        [cellController beginBindingsContextByRemovingPreviousBindings];
        [object bind:@"text" withBlock:^(id value) {
            bCellController.text = ([object text] && [[object text]length] > 0)? [object text] : _(@"kEmptyText");
        }];
        [cellController endBindingsContext];
        
        return cellController;
    }];
    
    CKFormBindedCollectionSection* section4 = [CKFormBindedCollectionSection sectionWithCollection:settings.userObjects factory:userObjectCellFactory headerTitle:_(@"kUserObjects")];
    
    CKTableViewCellController* addUserObjectCell = [CKTableViewCellController cellControllerWithTitle:_(@"kAdd") action:^(CKTableViewCellController *controller) {
        UserObject* newObject = [UserObject object];
        [settings.userObjects addObject:newObject];
    }];
    
    //This demonstrates an option cell whose values are defined in extended attributes.
    
    CKTableViewCellController* selectUserObject = [CKTableViewCellController cellControllerWithObject:settings keyPath:@"userObject"];
    [selectUserObject setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        [self updatePropertyCell:controller usingSettings:settings];
    }];
    selectUserObject.name = @"selectUserObject";
    
    CKFormSection* section5 = [CKFormSection sectionWithCellControllers:[NSArray arrayWithObjects:addUserObjectCell,selectUserObject,nil]];
    
    //Adds sections
    [form addSections:[NSArray arrayWithObjects:section1,section2,section3,section4,section5,nil]];
    
    //Manage the form state depending on the number of userObjects
    
    __block CKFormTableViewController* bForm = form;
    [form beginBindingsContextByRemovingPreviousBindings];
    [settings.userObjects bind:@"count" executeBlockImmediatly:YES withBlock:^(id value) {
        bForm.editableType = ([settings.userObjects count] > 0) ? CKTableCollectionViewControllerEditingTypeLeft : CKTableCollectionViewControllerEditingTypeNone;
        if([[ settings.userObjects allObjects]indexOfObjectIdenticalTo: settings.userObject] == NSNotFound){
            settings.userObject = nil;
        }
        [self updatePropertyCell:selectUserObject usingSettings:settings];
    }];
    [form endBindingsContext];
    
    form.viewWillAppearBlock = ^(CKViewController* controller, BOOL animated){
        [self updatePropertyCell:selectUserObject usingSettings:settings];
    };
    
    return form;
}

@end
