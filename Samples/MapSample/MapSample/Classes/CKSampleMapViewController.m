//
//  CKSampleMapViewController.m
//  MapSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleMapViewController.h"
#import "CKSampleMapModel.h"
#import "CKSampleMapDataSources.h"
#import "CKSampleMapModelCalloutViewController.h"

@implementation CKSampleMapViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (void)setup{
    self.title = _(@"kModelsViewControllerTitle");
    
    self.supportedInterfaceOrientations = CKInterfaceOrientationPortrait;
    
    //Customizing the zoom strategy
    self.includeUserLocationWhenZooming = NO;
    
    //setup the model collection associated to its data source
    CKArrayCollection* modelsCollection = [CKArrayCollection collectionWithFeedSource:[CKSampleMapDataSources feedSourceForModels]];
    
    __unsafe_unretained CKSampleMapViewController* bself = self;
    CKCollectionCellControllerFactory* modelsCellFactory = [CKCollectionCellControllerFactory factory];
    [modelsCellFactory addItemForObjectOfClass:[CKSampleMapModel class] withControllerCreationBlock:^(id object, NSIndexPath *indexPath) {
        CKSampleMapModel* model = (CKSampleMapModel*)object;
        return [bself mapAnnotationControllerForModel:model];
    }];
    
    
    //We'll display a filtered collection in the map controller in case some Model objects would have no geo location coordinates.
    //This collection is automatically updated in sync with the specified collection using the specified predicate to accept/reject objects
    
    CKFilteredCollection* filteredCollection = [CKFilteredCollection filteredCollectionWithCollection:modelsCollection usingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CKSampleMapModel* model = (CKSampleMapModel*)evaluatedObject;
        return model.latitude != 0 && model.longitude != 0;
    }]];
    
    
    //Setup the map to display the filtered collection using the specified annotation controller factory
    [self setupWithCollection:filteredCollection factory:modelsCellFactory];
}

- (CKMapAnnotationController*)mapAnnotationControllerForModel:(CKSampleMapModel*)model{
    //This illustrates a basic annotation controller displaying an object implementing the MKAnnotation Protocol (by setting its value)
    //we could have let its value to nil and set its coordinates and texts in the setup block using our model if  this model was not MKAnnotation.
    //MKAnnotationView are dynamically subclasses bu CKAnnotationView adding the capability to setup a UIViewController as the calloutView on demand (via a factory block)
    //Lets try to setup this.
    
    CKMapAnnotationController* annotationController = [CKMapAnnotationController annotationController];
    annotationController.value = model;
    annotationController.style = CKMapAnnotationCustom;
    
    //The init block is called when an annotationView needs to be created for the CKMapAnnotationController's identifier
    //We generally setup the view hierarchy here without setting any data
    
    [annotationController setInitBlock:^(CKMapAnnotationController *controller, MKAnnotationView *view) {
        
        view.image =[UIImage imageNamed:@"pin"];
        view.centerOffset = CGPointMake(0,-view.image.size.height / 2);
        
        //Here we do not need this as we creates a fully custom callout view controller that will manage this
        //view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }];
    
    
    //The setup block is called whether we create for the first time or we reuse the annotation view.
    //We generally get the views here by tag or by name and set/bind the data from the document model to the views.
    [annotationController setSetupBlock:^(CKMapAnnotationController *controller, MKAnnotationView *view) {
        
        //This code is not compatible will CKMapAnnotationPin yet unfortunately.
        CKAnnotationView* annotationView = (CKAnnotationView*)view;
        annotationView.calloutViewControllerCreationBlock = ^(CKMapAnnotationController* annotationController, CKAnnotationView* annotationView){
            CKSampleMapModelCalloutViewController* calloutViewController = [[CKSampleMapModelCalloutViewController alloc]initWithModel:annotationController.value];
            return calloutViewController;
        };
        
    }];
    
    //The accessory selection block is called when the user tap on the right callout accessory
    //Here we do not need this as we creates a fully custom callout view controller that will manage this selection
    /*
     [annotationController setAccessorySelectionBlock:^(CKMapAnnotationController *controller) {
     }];
     */
    
    return annotationController;
}

@end
