//
//  AppDelegate.h
//  CKStoreSample
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/* This sample demonstrates lots of the AppCoreKit features but we want to focus on two things in particular :
 
 1. The automatic serialization of model objects in the CKStore wich is a generic key/value Core Data model.
 2. An advanced way of creating forms editing your data models.
 
 We are using bindings explicitly or implicitly in some helpers used in this sample.
 If you're not already familiar with bindings, We suggest you start by looking at the BindingsSample.
 
 
 1. CKStore
 
      CKStore is a generic key/value Core Data Model allowing to save/load your data automatically.
      By Using CKObject as a base class for your data models, this is automatically done for you.
      Each instance of CKObject will get a uniqueId generated during the serialization phase allowing it to be
      identified in a unique way.
 
      To save a whole document hierarchy, you just need to set the root object's uniqueId before serializing it
      and you can load it using this same uniqueId.
 
      The CKObject extension for CKStore allow to serialize relational models using this manner of identifying the objects
      That means that if you have collections or pointer to some instances in your object hierarchy, the reference will be
      kept while saving/loading your data from the CKStore.
 
      Saving your Data:
 
         CKObject* YourObject = ???;
         CKObject* YourObject.uniqueId = @"00000000-0000-0000-0000-000000000010";
         [YourObject saveObjectToDomainNamed:@"YourDomain" recursive:YES];
 
      Loading you Data:
 
         CKObject* YourObject = [CKObject loadObjectWithUniqueId:@"00000000-0000-0000-0000-000000000010"];
 
      Lets look at CKSampleStoreUserSettingsModel.
 
 2. Forms
 
      Form is a view controller extending the UITableView capabilities. Each TableView row is backup by a CKTableViewCellController
      that provides the base mechanism to setup, allocate and reuse tableView cells when needed.
      It follows the model of UIViewController/UIView in a sense that, the cell controller will manage a UITableViewCell when the associated
      row will arrive on screen.
 
      Form provides a descriptive way for representing table views as well as powerfull implementation of lots of build in cell controllers
      to edit and display all kind of properties. (String, Numbers, BOOL, Date, Native types, CGTypes, ...)
      These implementation are build on top of the objective-C runtime stack provided in AppCoreKit so that you can get a table view row
      that does the job in a single line of code.
 
          CKTableViewCellController* cellController = [CKTableViewCellController cellControllerForObject:YourObject keyPath:@"YourProperty"];
 
 
      Form also provides a way to represent a collection of model objects as a table view section. This kind of sections automatically
      register for changes in this collection in order to stay in sync. Remove a row in this section and it will remove the object in your model.
      Add or remove objects in you model and it will add/remove the rows in your section without have to implement glue code.
 
 
      Lets look at CKSampleStoreSettingsViewController.
 
*/
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
