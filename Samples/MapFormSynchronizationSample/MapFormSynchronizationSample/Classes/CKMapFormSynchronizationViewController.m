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
@property(nonatomic,retain) CKMapCollectionViewController* mapViewController;
@property(nonatomic,retain) CKArrayCollection* collection;
@end

@implementation CKMapFormSynchronizationViewController

- (void)postInit{
    [super postInit];
    
    self.title = @"Map/Form Synchronization Sample";
    self.style = UITableViewStylePlain;
    
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
   is displayed as a tableHeaderView in the current form table view controller.
 
   We have to manage viewWillAppear, viewWillDisappear, viewDidAppear and viewDidDisappear manually.
   Optionally, we'll have to forward device rotation callbacks if we wanted to support orientation changes
*/

- (void)setupMap{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKCollectionCellControllerFactory* mapFactory = [CKCollectionCellControllerFactory factory];
    [mapFactory addItemForObjectOfClass:[NSObject class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        return [bself mapAnnotationControllerForObject:object];
    }];
    
    CKFilteredCollection* filteredCollection = [CKFilteredCollection filteredCollectionWithCollection:self.collection usingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CKMapFormSynchronizationModel* venue = (CKMapFormSynchronizationModel*)evaluatedObject;
        return venue.coordinate.latitude != 0 && venue.coordinate.longitude != 0;
    }]];
    
    self.mapViewController = [[CKMapCollectionViewController alloc]initWithCollection:filteredCollection factory:mapFactory];
    self.mapViewController.includeUserLocationWhenZooming = NO;
}

- (CKMapAnnotationController*)mapAnnotationControllerForObject:(CKMapFormSynchronizationModel*)venue{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKMapAnnotationController* controller = [[CKMapAnnotationController alloc]init];
    controller.value = venue;
    
    [controller setSetupBlock:^(CKMapAnnotationController *controller, MKAnnotationView *view) {
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }];
    
    [controller setAccessorySelectionBlock:^(CKMapAnnotationController *controller) {
        [bself didSelectVenueDetailsInMap:venue];
    }];
    
    return controller;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView* mapView = [self.mapViewController view];
    mapView.frame = CGRectMake(0,0,320,300);
    
    self.tableView.tableHeaderView = mapView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mapViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mapViewController viewDidDisappear:animated];
}


#pragma mark Form Management

- (void)setupForm{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    CKCollectionCellControllerFactory* factory = [CKCollectionCellControllerFactory factory];
    [factory addItemForObjectOfClass:[NSObject class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        return [bself cellControllerForObject:object];
    }];
    
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:self.collection factory:factory];
    [self addSections:@[section]];
}

- (CKTableViewCellController*)cellControllerForObject:(CKMapFormSynchronizationModel*)venue{
    __unsafe_unretained CKMapFormSynchronizationViewController* bself = self;
    
    return [CKTableViewCellController cellControllerWithTitle:venue.name subtitle:venue.phone action:^(CKTableViewCellController *controller) {
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
