//
//  CKSampleMapModelCalloutViewController.m
//  MapSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleMapModelCalloutViewController.h"

@interface CKSampleMapModelCalloutViewController()
@property(nonatomic,retain) CKSampleMapModel* model;
@end

@implementation CKSampleMapModelCalloutViewController

- (id)initWithModel:(CKSampleMapModel*)theModel{
    self = [super init];
    self.model = theModel;
    [self setup];
    return self;
}

- (void)setup{
    __unsafe_unretained CKSampleMapModelCalloutViewController* bself = self;
    
    //This could have been setuped in stylesheets
    self.style = UITableViewStylePlain;
    
    //Creates a cell controller displaying our model details
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:self.model.name
                                                                                subtitle:self.model.address
                                                                            defaultImage:[UIImage imageNamed:@"placeholder"]
                                                                                imageURL:self.model.imageUrl
                                                                               imageSize:CGSizeMake(40,40)
                                                                                  action:^(CKTableViewCellController *controller) {
                                                                                      [bself didSelectModelDetails];
                                                                                  }];
    
    //This could have been setuped in stylesheets
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    //Adds a section with the cell controller in the form
    [self addSections:@[ [CKFormSection sectionWithCellControllers:@[cellController] ]] ];
    
    //We setup the width of the form and a random height that will get adjusted later using the real cell height.
    //Setting the width will force the cell to compute its height using this specified width.
    self.contentSizeForViewInPopover = CGSizeMake(250,100);
    
    //Here we register a binding between the cell controller size property and a block to execute asynchronously when this property get's computed.
    //This updates the size of the form at this particular instant.
    
    //Bindings unify the way you register for asynchronous notification. It is built on top of KVO, NotificationCenter and Controls Target/Action.
    
    //Binding contexts allow to manage the life duration of these connections (bindings). In this case, the binding defined in this scope will get killed when the form gets killed.
    //It is particularly usefull to manage the life duration of a bigger number of bindings on object properties, control events or notifications.
    //cf. (NSObject+Bindings.h in AppCoreKit).
    
    [self beginBindingsContextByRemovingPreviousBindings];
    [cellController bind:@"size" withBlock:^(id value) {
        CGSize size = cellController.size;
        bself.contentSizeForViewInPopover = CGSizeMake(250,size.height);
    }];
    [self endBindingsContext];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

- (void)didSelectModelDetails{
    NSString* message = [NSString stringWithFormat:_(@"kAlertMessage_ModelTap"),self.model.name];
    CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertTitle_ModelTap") message:message];
    [alert addButtonWithTitle:_(@"kOk") action:nil];
    [alert show];
}

@end
