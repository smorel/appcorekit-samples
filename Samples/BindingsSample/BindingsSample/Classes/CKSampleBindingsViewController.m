//
//  CKSampleBindingsViewController.m
//  BindingsSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleBindingsViewController.h"
#import "CKSampleBindingsModel.h"


static NSString* kStrings[3]       = { @"String1", @"String2", @"MultiLine String\n2 Lines" };
static NSInteger kNumbers[3]       = { 1, 2, 3 };
static NSString* kNotifications[3] = { @"Notification1", @"Notification2", @"Notification3" };

@interface CKSampleBindingsViewController()
@property(nonatomic,retain) CKSampleBindingsModel* model;
@end

@implementation CKSampleBindingsViewController

- (void)postInit{
    [super postInit];
    
    self.model = [CKSampleBindingsModel object];
    [self setup];
}

- (void)setup{
    self.title = _(@"kModelsViewControllerTitle");
    
    NSArray* cells = @[
        [self cellControllerForString],
        [self cellControllerForInteger],
        [self cellControllerForNotification],
        [self cellControllerForDate],
        [self cellControllerForButtons],
        [self cellControllerForContentOffset]
    ];
    
    //Adding a section with the cell controllers
    [self addSections:@[ [CKFormSection sectionWithCellControllers:cells] ]];
    
    //Binding the form title with the model's string property
    [self beginBindingsContextByRemovingPreviousBindings];
    [self.model bind:@"string" toObject:self withKeyPath:@"title"];
    [self endBindingsContext];
}



- (CKTableViewCellController*)cellControllerForString{
    __unsafe_unretained CKSampleBindingsViewController* bself = self;
    
    __block NSInteger currentValueIndex = -1;
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyString")
                                                                                            action:^(CKTableViewCellController *controller) {
        ++currentValueIndex;
        if(currentValueIndex >= 3) currentValueIndex = 0;
        
        //Setting this property implicitly calls stringChanged on Model and cellController detailText will automatically get set thanks to the binding.
        bself.model.string = kStrings[currentValueIndex];
    }];
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    [cellController beginBindingsContextByRemovingPreviousBindings];
    [self.model bind:@"string" toObject:cellController withKeyPath:@"detailText"];
    [cellController endBindingsContext];
    
    return cellController;
}



- (CKTableViewCellController*)cellControllerForInteger{
    __unsafe_unretained CKSampleBindingsViewController* bself = self;
    
    __block NSInteger currentValueIndex = -1;
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyInteger")
                                                                                            action:^(CKTableViewCellController *controller) {
        ++currentValueIndex;
        if(currentValueIndex >= 3) currentValueIndex = 0;
        
        //Setting this property implicitly calls integerChanged on Model and cellController detailText will automatically get set thanks to the binding.
        //Bindings integrates our conversion system. Almost any type can be converted to any type automatically.
        //This conversion system is based on an informal protocol and can be extended as needed to handle conversions that are not supported by default.
        bself.model.integer = kNumbers[currentValueIndex];
    }];
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    [cellController beginBindingsContextByRemovingPreviousBindings];
    [bself.model bind:@"integer" toObject:cellController withKeyPath:@"detailText"];
    [cellController endBindingsContext];

    return cellController;
}



- (CKTableViewCellController*)cellControllerForNotification{
    __block NSInteger currentValueIndex = -1;
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kSendNotification")
                                                                                          subtitle:_(@"kSendNotificationDefaultSubtitle")
                                                                                            action:^(CKTableViewCellController *controller) {
        ++currentValueIndex;
        if(currentValueIndex >= 3) currentValueIndex = 0;
        
        NSString* str = kNotifications[currentValueIndex];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomNotif"
                                                           object:nil
                                                         userInfo:@{ @"message" : str} ];
    }];
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    __unsafe_unretained CKTableViewCellController* bCellController = cellController;
    
    [cellController beginBindingsContextByRemovingPreviousBindings];
    [NSNotificationCenter bindNotificationName:@"CustomNotif" withBlock:^(NSNotification *notification) {
        bCellController.detailText = [[notification userInfo]objectForKey:@"message"];
    }];
    [cellController endBindingsContext];
    
    return cellController;
}



- (CKTableViewCellController*)cellControllerForDate{
    __unsafe_unretained CKSampleBindingsViewController* bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyDate")
                                                                                            action:^(CKTableViewCellController *controller) {
        NSTimeInterval randomInterval = ((float)rand() / (float)RAND_MAX) * 99999999;
        bself.model.date = [NSDate dateWithTimeIntervalSince1970:randomInterval];
    }];
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    __block CKTableViewCellController* bCellController = cellController;
    [cellController beginBindingsContextByRemovingPreviousBindings];
    [self.model bind:@"date" executeBlockImmediatly:YES withBlock:^(id value) {
        NSString* str = [bself.model.date stringWithDateFormat: @"dd MMMM YYYY"];
        bCellController.detailText = str;
    }];
    [cellController endBindingsContext];

    return cellController;
}



- (CKTableViewCellController*)cellControllerForContentOffset{
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"kTableContentOffset")
                                                                                            action:nil];
    cellController.cellStyle = CKTableViewCellStyleSubtitle2;
    
    [cellController beginBindingsContextByRemovingPreviousBindings];
    
    //Here we bind on tableView.contentOffset property because the tableView doesn't exists yet.
    //It will get created in form's viewDidLoad method when the form gets displayed in a container controller.
    //By this way, we ensure that if the tableView or if the contentOffset of the tableView change, the detailText of the cell controller will get updated.
    
    [self bind:@"tableView.contentOffset" toObject:cellController withKeyPath:@"detailText"];
    [cellController endBindingsContext];
    
    return cellController;
}



- (CKTableViewCellController*)cellControllerForButtons{
    
    //Here we set the name of the cell controller.
    //The name is part of the reuse identifier. That lets you choose wich cell could be reused.
    //In our example we don't have enough cells displayed to have reuse problems.
    //But if you experience weird reuse behaviour, ensure to set the name to cell controllers to make them having a unique reuse identifier!
    //The name is also usefull to target specifically cell controller in stylesheets.
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithName:@"ButtonsCell"];
    
    [cellController setInitBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        CGFloat buttonWidth = (cell.contentView.width - (4 * 10)/*Margins*/) / 3 ;
        for(int i =0;i<3;++i){
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.name = [NSString stringWithFormat:@"Button%d",i];
            [button setTitle:button.name forState:UIControlStateNormal];
            
            button.width = buttonWidth;
            button.x = 10 + (i * (buttonWidth + 10));
            button.height = cell.contentView.height - (2 * 10) /*Margins*/;
            button.y = 10;
            
            button.autoresizingMask = UIViewAutoresizingFlexibleSize;
            
            [cell.contentView addSubview:button];
        }
    }];
    
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        
        //Here we open the context on the table view cell as we directly bind views contained by the cell.
        //This is important because the cell is reused. By this way, the next time it is reused, another instance of cell controller named "ButtonsCell"
        //will get setuped with this same cell. And as we open the binding context by removing previous bindings,
        //that means the bindings that had been setup on the buttons by the previous controller will get flushed and replaced by
        //the new one establishing the connection between the cell subviews and the new cell controller.
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        for(int i=0;i<3;++i){
            NSString* name = [NSString stringWithFormat:@"Button%d",i];
            UIButton* button = [cell.contentView viewWithKeyPath:name];
            
            [button bindEvent:UIControlEventTouchUpInside withBlock:^{
                NSString* message = [NSString stringWithFormat:_(@"kAlertViewMessage_UIControlBinding"),name];
                CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertViewTitle_UIControlBinding") message:message];
                [alert addButtonWithTitle:_(@"kOk") action:nil];
                [alert show];
            }];
        }
        [cell endBindingsContext];
    }];

    
    return cellController;
    
}

@end
