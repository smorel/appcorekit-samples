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
    self.style = UITableViewStylePlain;
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}

- (void)setup{
    [self clear];
    
    __unsafe_unretained CKSampleMapModelCalloutViewController* bself = self;
    
    //This could have been setuped in stylesheets
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
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
    
    self.view.width = 250;
    self.contentSizeForViewInPopover = [cellController computeSize];
}

- (void)didSelectModelDetails{
    NSString* message = [NSString stringWithFormat:_(@"kAlertMessage_ModelTap"),self.model.name];
    CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertTitle_ModelTap") message:message];
    [alert addButtonWithTitle:_(@"kOk") action:nil];
    [alert show];
}

@end
