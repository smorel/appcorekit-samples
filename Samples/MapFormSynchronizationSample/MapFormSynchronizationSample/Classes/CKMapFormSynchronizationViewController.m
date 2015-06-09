//
//  CKMapFormSynchronizationViewController.m
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKMapFormSynchronizationViewController.h"
#import "CKMapFormSynchronizationDataSources.h"
#import "CKMapFormSynchronizationModel.h"

@interface CKMapFormSynchronizationViewController ()
@property(nonatomic,retain) CKMapViewController* mapViewController;
@property(nonatomic,retain) CKArrayCollection* collection;
@end

@implementation CKMapFormSynchronizationViewController

- (void)postInit{
    [super postInit];
    
    self.title = @"Map/Form Synchronization Sample";
    
    //The collection we want to display in map and form
    //who's content is fetched asynchronously when scrolling in the table view.
    self.collection = [CKArrayCollection collectionWithFeedSource:[CKMapFormSynchronizationDataSources sourceForFoursquareVenuesNear:@"Montreal, Qc" section:@"arts"]];
    
    [self setupMap];
    [self setupForm];
}

#pragma mark Map Management

/* This sample illustrates how to take advantage of view controllers for splitting the logic
   and integrate this third party controller's view into our view hierarchy.
   Here, we have a CKMapCollectionViewController taking care of synchronizing the map who's view
   is displayed as a section header view in the current form table view controller section.
 
   We have to manage viewWillAppear, viewWillDisappear, viewDidAppear and viewDidDisappear manually.
   Optionally, we'll have to forward device rotation callbacks if we wanted to support orientation changes
*/

- (void)setupMap{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKReusableViewControllerFactory* mapFactory = [CKReusableViewControllerFactory factory];
    [mapFactory registerFactoryForObjectOfClass:[NSObject class] factory:^CKReusableViewController *(id object, NSIndexPath *indexPath) {
        return [bself mapAnnotationControllerForObject:object];
    }];
    
    CKFilteredCollection* filteredCollection = [CKFilteredCollection filteredCollectionWithCollection:self.collection usingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CKMapFormSynchronizationModel* venue = (CKMapFormSynchronizationModel*)evaluatedObject;
        return venue.coordinate.latitude != 0 && venue.coordinate.longitude != 0;
    }]];
    
    self.mapViewController = [[CKMapViewController alloc]init];
    [self.mapViewController addSection:[CKCollectionSection sectionWithCollection:filteredCollection factory:mapFactory] animated:NO];
    self.mapViewController.includeUserLocationWhenZooming = NO;
    self.mapViewController.fixedHeight = 150;
}

- (CKReusableViewController*)mapAnnotationControllerForObject:(CKMapFormSynchronizationModel*)venue{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKReusableViewController* controller = [[CKReusableViewController alloc]init];
    controller.mapAnnotation = venue;
    
    controller.viewWillAppearBlock = ^(UIViewController* controller, BOOL animated){
        CKReusableViewController* rc = (CKReusableViewController*)controller;
        rc.mapAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rc.mapAnnotationView.canShowCallout = YES;
    };
    
    controller.didSelectAccessoryBlock = ^(CKReusableViewController* controller){
        [bself didSelectVenueDetailsInMap:venue];
    };
    
    return controller;
}


#pragma mark Form Management

- (void)setupForm{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKReusableViewControllerFactory* factory = [CKReusableViewControllerFactory factory];
    [factory registerFactoryForObjectOfClass:[NSObject class] factory:^CKReusableViewController *(id object, NSIndexPath *indexPath) {
        return [bself cellControllerForObject:object];
    }];
    
    CKCollectionSection* section = [CKCollectionSection sectionWithCollection:self.collection factory:factory];
    
    CKReusableViewController* mapHeader = [CKReusableViewController controller];
    mapHeader.viewWillAppearBlock = ^(UIViewController* controller, BOOL animated){
        controller.layoutBoxes = [CKArrayCollection collectionWithObjectsFromArray:@[ self.mapViewController]];
    };
    section.headerViewController = mapHeader;
    
    [self addSections:@[section] animated:NO];
}

- (CKReusableViewController*)cellControllerForObject:(CKMapFormSynchronizationModel*)venue{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    return [CKReusableViewController controllerWithTitle:venue.name subtitle:venue.phone action:^(CKStandardContentViewController *controller) {
        [bself didSelectVenueDetailsInForm:venue];
    }];
}


#pragma mark User Interaction Management

- (void)didSelectVenueDetailsInMap:(CKMapFormSynchronizationModel*)venue{
    CKAlertView* alert = [[CKAlertView alloc]initWithTitle:@"Map" message:[NSString stringWithFormat:@"You've selected the '%@' venue in map",venue.name ]];
    [alert addButtonWithTitle:@"OK" action:nil];
    [alert show];
}

- (void)didSelectVenueDetailsInForm:(CKMapFormSynchronizationModel*)venue{
    CKAlertView* alert = [[CKAlertView alloc]initWithTitle:@"Form" message:[NSString stringWithFormat:@"You've selected the '%@' venue in form",venue.name ]];
    [alert addButtonWithTitle:@"OK" action:nil];
    [alert show];
}

@end
