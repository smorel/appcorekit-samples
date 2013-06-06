//
//  CKSampleStoreSettingsViewController.m
//  CKStoreSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleStoreSettingsViewController.h"
#import "CKSampleStoreUserObjectViewController.h"

@interface CKSampleStoreSettingsViewController()
@property(nonatomic,retain) CKSampleStoreUserSettingsModel* settings;
@end

@implementation CKSampleStoreSettingsViewController

- (id)initWithSettings:(CKSampleStoreUserSettingsModel*)theSettings{
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
      [self sectionForFamily],
      [self sectionForUserObjects],
      [self sectionForManagingUserObjects]
    ]];
    
    //Manage the form state depending on the number of userObjects
    
    __unsafe_unretained CKSampleStoreSettingsViewController* bSelf = self;
    [self beginBindingsContextByRemovingPreviousBindings];
    [self.settings.userObjects bind:@"count" executeBlockImmediatly:YES withBlock:^(id value) {
        //Show/hide the edit navigation bar button
        bSelf.editableType = ([bSelf.settings.userObjects count] > 0) ? CKTableCollectionViewControllerEditingTypeLeft : CKTableCollectionViewControllerEditingTypeNone;
        
        //Updates the settings model if it's selected user gets removed
        if([[ bSelf.settings.userObjects allObjects]indexOfObjectIdenticalTo: bSelf.settings.userObject] == NSNotFound){
            bSelf.settings.userObject = nil;
        }
    }];
    [self endBindingsContext];
    
    
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



/* This method shows how to display a collection of objects as a table view section.
   CKFormBindedCollectionSection provides an internal binding mechanism that ensure it's visual representation
   will stay in sync with the collection's content.
   If objects gets inserted/removed from the model's collection, the section will automatically insert/remove
   the corresponding cell controllers from its reprsentation.
 
   As this is completly asynchronous and the CKFormBindedCollectionSection will create cell controllers for representing the
   collection's objects when they get inserted, CKFormBindedCollectionSection need a factory (CKCollectionCellControllerFactory) that gives the ability to create
   these view controllers when needed.
 
   CKCollectionCellControllerFactory is a base implementation that is use by CKCollectionViewController and CKFormBindedCollectionSection.
   As Maps, Carousel, Table and other view controllers are based on this same implementation, that's why you're using or more generic implementation
   for the factory.
 */

- (CKFormSectionBase*)sectionForUserObjects{
    __unsafe_unretained CKSampleStoreSettingsViewController* bSelf = self;
    
    //Setup the cell controller factory for creating cell controllers for CKSampleStoreUserObjectModel objects
    CKCollectionCellControllerFactory* userObjectCellFactory = [CKCollectionCellControllerFactory factory];
    [userObjectCellFactory addItemForObjectOfClass:[CKSampleStoreUserObjectModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        CKSampleStoreUserObjectModel* userObject = (CKSampleStoreUserObjectModel*)object;
        return [bSelf cellControllerForUserObject:userObject];
    }];
    
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:self.settings.userObjects factory:userObjectCellFactory headerTitle:_(@"kUserObjects")];
    
    [section addFooterCellController:[self cellControllerForAddingUserObject]];
    
    return section;
}


- (CKTableViewCellController*)cellControllerForAddingUserObject{
    __unsafe_unretained CKSampleStoreSettingsViewController* bSelf = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kAdd") action:^(CKTableViewCellController *controller) {
        CKSampleStoreUserObjectModel* newObject = [CKSampleStoreUserObjectModel object];
        [bSelf.settings.userObjects addObject:newObject];
    }];
    
    return cellController;
}


- (CKTableViewCellController*)cellControllerForUserObject:(CKSampleStoreUserObjectModel*)userObject{
    NSString* text = ([userObject text] && [[userObject text]length] > 0)? [userObject text] : _(@"kEmptyText");
    
    //Creates a simple cell controller pushing an editing view controller
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:text action:^(CKTableViewCellController *controller) {
        CKSampleStoreUserObjectViewController* edition = [[CKSampleStoreUserObjectViewController alloc]initWithUserObject:userObject];
        [controller.containerController.navigationController pushViewController:edition animated:YES];
    }];
    cellController.name = @"UserObjectCell"; //For reuse and stylesheets
    cellController.flags = CKItemViewFlagRemovable | CKItemViewFlagSelectable;
    
    //Binds on object text to update the cell controller text
    __unsafe_unretained CKTableViewCellController* bCellController = cellController;
    [cellController beginBindingsContextByRemovingPreviousBindings];
    [userObject bind:@"text" withBlock:^(id value) {
        bCellController.text = ([userObject text] && [[userObject text]length] > 0)? [userObject text] : _(@"kEmptyText");
    }];
    [cellController endBindingsContext];
    
    return cellController;
}

- (CKFormSectionBase*)sectionForManagingUserObjects{
    return [CKFormSection sectionWithCellControllers:@[
                [self cellControllerForSelectingUserObject]
    ]];
}

- (void)updateSelectUserCellController:(CKTableViewCellController*)controller usingSettings:(CKSampleStoreUserSettingsModel*)settings{
    BOOL hasValidUserObjects = [self.settings hasValidUserObjects];
    
    //Updates selectUserObject detailText when number of objects in userObjects changes.
    controller.accessoryType  = hasValidUserObjects ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    controller.flags          = hasValidUserObjects ? CKItemViewFlagSelectable : CKItemViewFlagNone;
    controller.selectionStyle = hasValidUserObjects ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    
    BOOL canChooseUserObject = (settings.userObject != nil && [settings.userObject text] != nil && [[settings.userObject text]length] > 0);
    
    NSString* text = canChooseUserObject ? [settings.userObject text] : _(@"userObject_Placeholder");
    
    controller.detailText = hasValidUserObjects ? text : _(@"kNoUserObjects");
}

- (CKTableViewCellController*)cellControllerForSelectingUserObject{
    __unsafe_unretained CKSampleStoreSettingsViewController* bSelf = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithObject:self.settings keyPath:@"userObject"];
    cellController.name = @"selectUserObject";
    
    //As cellControllerWithObject:keyPath: sets the text using the localized value _(@"userObject") when initializing the cell,
    //And we have a very special case here where this text depends on hasValidUserObjects and userObject in settings,
    //We ensure by setuping the cell using setSetupBlock that the default values have been set previously and we have full control
    //on the controller's properties here
    
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        [bSelf updateSelectUserCellController:controller usingSettings:bSelf.settings];
    }];
    
    __unsafe_unretained CKTableViewCellController* bCellController = cellController;
    
    [cellController beginBindingsContextByRemovingPreviousBindings];
    
    [self.settings bind:@"userObject" withBlock:^(id value) {
        [bSelf updateSelectUserCellController:bCellController usingSettings:bSelf.settings];
    }];
    [self.settings.userObjects bind:@"count" withBlock:^(id value) {
        [bSelf updateSelectUserCellController:bCellController usingSettings:bSelf.settings];
    }];
    
    [cellController endBindingsContext];
    
    return cellController;
}

@end
