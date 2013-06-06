//
//  ViewControllerFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllerFactory.h"

@implementation ViewControllerFactory

+ (CKViewController*)viewControllerForModelCallout:(Model*)model modelSelectionBlock:(void(^)(Model* model))modelSelectionBlock{
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"CalloutController"];
    __block CKFormTableViewController* bform = form;
    
    //This could have been setuped in stylesheets
    form.style = UITableViewStylePlain;
    form.viewDidLoadBlock = ^(CKViewController* controller){
        bform.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        bform.tableView.scrollEnabled = NO;
    };
    
    //Creates a cell controller displaying our model details
    CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:model.name subtitle:model.address 
                                                                            defaultImage:[UIImage imageNamed:@"placeholder"] 
                                                                                imageURL:model.imageUrl 
                                                                               imageSize:CGSizeMake(40,40) 
                                                                                  action:^(CKTableViewCellController *controller) {
        if(modelSelectionBlock){
            modelSelectionBlock(model);
        }
    }];
    
    //This could have been setuped in stylesheets
    cell.cellStyle = CKTableViewCellStyleSubtitle2;
    
    //Adds a section with the cell controller in the form
    [form addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:[NSArray arrayWithObject:cell]]]];
    
    //We setup the width of the form and a random height that will get adjusted later using the real cell height.
    //Setting the width will force the cell to compute its height using this specified width.
    form.contentSizeForViewInPopover = CGSizeMake(250,100);
    
    //Here we register a binding between the cell controller size property and a block to execute asynchronously when this property get's computed.
    //This updates the size of the form at this particular instant.
    
    //Bindings unify the way you register for asynchronous notification. It is built on top of KVO, NotificationCenter and Controls Target/Action.
    
    //Binding contexts allow to manage the life duration of these connections (bindings). In this case, the binding defined in this scope will get killed when the form gets killed.
    //It is particularly usefull to manage the life duration of a bigger number of bindings on object properties, control events or notifications.
    //cf. (NSObject+Bindings.h in AppCoreKit).
    
    [form beginBindingsContextByRemovingPreviousBindings];
    [cell bind:@"size" withBlock:^(id value) {
        CGSize size = cell.size;
        bform.contentSizeForViewInPopover = CGSizeMake(250,size.height);
    }];
    [form endBindingsContext];
    
    return form;
}

+ (CKViewController*)viewControllerForModels:(CKCollection*)models modelSelectionBlock:(void(^)(Model* model))modelSelectionBlock{
    
    CKCollectionCellControllerFactory* modelsCellFactory = [CKCollectionCellControllerFactory factory];
    [modelsCellFactory addItemForObjectOfClass:[Model class] withControllerCreationBlock:^(id object, NSIndexPath *indexPath) {
        Model* model = (Model*)object;
        
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
                return [ViewControllerFactory viewControllerForModelCallout:annotationController.value modelSelectionBlock:modelSelectionBlock];
            };
            
        }];
        
        //The accessory selection block is called when the user tap on the right callout accessory
        //Here we do not need this as we creates a fully custom callout view controller that will manage this selection
        /*
        [annotationController setAccessorySelectionBlock:^(CKMapAnnotationController *controller) {
            if(modelSelectionBlock){
                modelSelectionBlock(model);
            }
        }];
         */
        
        return annotationController;
    }];
    
    
    //We'll display a filtered collection in the map controller in case some Model objects would have no geo location coordinates.
    //This collection is automatically updated in sync with the specified collection using the specified predicate to accept/reject objects
    
    CKFilteredCollection* filteredCollection = [CKFilteredCollection filteredCollectionWithCollection:models usingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Model* model = (Model*)evaluatedObject;
        return model.latitude != 0 && model.longitude != 0;
    }]];
    
    CKMapCollectionViewController* map = [CKMapCollectionViewController controllerWithName:@"mapControllerForModels"];
    map.supportedInterfaceOrientations = CKInterfaceOrientationPortrait;
    
    //Customizing the zoom strategy
    map.includeUserLocationWhenZooming = NO;
    
    //Setup the map to display the filtered collection using the specified annotation controller factory
    [map setupWithCollection:filteredCollection factory:modelsCellFactory];
    return map;
}

@end
