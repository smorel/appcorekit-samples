//
//  ViewControllerFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllerFactory.h"

@interface Model : CKObject
@property(nonatomic,copy) NSString* string;
@property(nonatomic,assign) NSInteger integer;
@property(nonatomic,copy) NSDate* date;
@end

@implementation Model
@synthesize string,integer,date;

- (void)postInit{
    [super postInit];
    self.string = @"Default String";
    self.integer = -1;
    self.date = [NSDate date];
}

//CKObject uses runtime and an informal dynamic protocol, based on KVO notifications, to notify itself when a property has been set.
//If you implement -(void)yourPropertyNameChanged, it will be called automatically.
//This avoid to overload setters and potential errors when you change the property attributes from retain to copy or assign.

- (void)stringChanged{
    NSLog(@"Model : string property has been set to '%@'",self.string);
}

- (void)integerChanged{
    NSLog(@"Model : integer property has been set to '%d'",self.integer);
}

- (void)dateChanged{
    NSLog(@"Model : date property has been set to '%@'",self.date);
}

@end


static NSString* kStrings[3] = { @"String1", @"String2", @"MultiLine String\n2 Lines" };
static NSInteger kNumbers[3] = { 1, 2, 3 };
static NSString* kNotifications[3] = { @"Notification1", @"Notification2", @"Notification3" };


@implementation ViewControllerFactory

+ (CKTableViewCellController*)cellControllerWithButtons{
    
    //Here we set the name of the cell controller.
    //The name is part of the reuse identifier. That lets you choose wich cell could be reused.
    //In our example we don't have enough cells displayed to have reuse problems.
    //But if you experience weird reuse behaviour, ensure to set the name to cell controllers to make them having a unique reuse identifier!
    //The name is also usefull to target specifically tese cell controller in stylesheets.
    
    CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithName:@"ButtonsCell"];
    [cell setInitBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        CGFloat buttonWidth = (cell.contentView.width - (4 * 10)/*Margins*/) / 3 ;
        for(int i =0;i<3;++i){
            UIButton* bu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            bu.name = [NSString stringWithFormat:@"Button%d",i];
            [bu setTitle:bu.name forState:UIControlStateNormal];
            
            bu.width = buttonWidth;
            bu.x = 10 + (i * (buttonWidth + 10));
            bu.height = cell.contentView.height - (2 * 10) /*Margins*/;
            bu.y = 10;
            
            bu.autoresizingMask = UIViewAutoresizingFlexibleSize;
            
            [cell.contentView addSubview:bu];
        }
    }];
    
    return cell;
}

+ (CKViewController*)viewControllerForBindingsSample{
    Model* model = [Model sharedInstance];
    
    CKFormTableViewController* form = [CKFormTableViewController controller];
    form.title = _(@"kModelsViewControllerTitle");
    
    NSMutableArray* cells = [NSMutableArray array];
    
    //Strings
    {
        __block NSInteger currentValueIndex = -1;
        CKTableViewCellController* valueCell = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyString") action:^(CKTableViewCellController *controller) {
            ++currentValueIndex;
            if(currentValueIndex >= 3) currentValueIndex = 0;
            
            //Setting this property implicitly calls stringChanged on Model and valueCell text will automatically get set thanks to the binding.
            model.string = kStrings[currentValueIndex];
        }];
        valueCell.cellStyle = CKTableViewCellStyleSubtitle2;
        
        [valueCell beginBindingsContextByRemovingPreviousBindings];
        [model bind:@"string" toObject:valueCell withKeyPath:@"detailText"];
        [valueCell endBindingsContext];
        
        [cells addObject:valueCell];
    }
    
    
    //Integer
    {
        __block NSInteger currentValueIndex = -1;
        CKTableViewCellController* valueCell = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyInteger") action:^(CKTableViewCellController *controller) {
            ++currentValueIndex;
            if(currentValueIndex >= 3) currentValueIndex = 0;
            
            //Setting this property implicitly calls integerChanged on Model and valueCell text will automatically get set thanks to the binding.
            //Bindings integrates our conversion system. Almost any type can be converted to any type automatically.
            //This conversion system is based on an informal protocol and can be extended as needed to handle conversions that are not supported by default.
            model.integer = kNumbers[currentValueIndex];
        }];
        valueCell.cellStyle = CKTableViewCellStyleSubtitle2;
        
        [valueCell beginBindingsContextByRemovingPreviousBindings];
        [model bind:@"integer" toObject:valueCell withKeyPath:@"detailText"];
        [valueCell endBindingsContext];
        
        [cells addObject:valueCell];
    }   
    
    //Notifications
    {
        __block NSInteger currentValueIndex = -1;
        CKTableViewCellController* valueCell = [CKTableViewCellController cellControllerWithTitle:_(@"kSendNotification") subtitle:_(@"kSendNotificationDefaultSubtitle") action:^(CKTableViewCellController *controller) {
            ++currentValueIndex;
            if(currentValueIndex >= 3) currentValueIndex = 0;
            
            NSString* str = kNotifications[currentValueIndex];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomNotif" object:nil userInfo:[NSDictionary dictionaryWithObject:str forKey:@"message"]];
        }];
        valueCell.cellStyle = CKTableViewCellStyleSubtitle2;
        
        __block CKTableViewCellController* bvalueCell = valueCell;
        [valueCell beginBindingsContextByRemovingPreviousBindings];
        [NSNotificationCenter bindNotificationName:@"CustomNotif" withBlock:^(NSNotification *notification) {
            bvalueCell.detailText = [[notification userInfo]objectForKey:@"message"];
        }];
        [valueCell endBindingsContext];
        
        [cells addObject:valueCell];
    }
    
    //Date
    {
        CKTableViewCellController* valueCell = [CKTableViewCellController cellControllerWithTitle:_(@"kModifyDate") action:^(CKTableViewCellController *controller) {
            NSTimeInterval randomInterval = ((float)rand() / (float)RAND_MAX) * 99999999;
            model.date = [NSDate dateWithTimeIntervalSince1970:randomInterval];
        }];
        valueCell.cellStyle = CKTableViewCellStyleSubtitle2;
        
        __block CKTableViewCellController* bvalueCell = valueCell;
        [valueCell beginBindingsContextByRemovingPreviousBindings];
        [model bind:@"date" executeBlockImmediatly:YES withBlock:^(id value) {
            NSString* str = [model.date stringWithDateFormat: @"dd MMMM YYYY"]; 
            bvalueCell.detailText = str;
        }];
        [valueCell endBindingsContext];
        
        [cells addObject:valueCell];
    }   
    
    //Buttons
    {
        CKTableViewCellController* cell = [self cellControllerWithButtons];
        [cell setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
            
            //Here we open the context on the table view cell as we directly bind views contained by the cell.
            //This is important in case the cell is reused. By this way, the next time it is reused, another instance of cell controller
            //will get setuped with this same cell. And as we open the binding context by removing previous bindings,
            //that means the bindings that had been setuped on the buttons by the previous controller will get flushed and replaced by
            //the new one establishing the connection between the cell and the new cell controller.
            
            [cell beginBindingsContextByRemovingPreviousBindings];
            for(int i=0;i<3;++i){
                NSString* name = [NSString stringWithFormat:@"Button%d",i];
                UIButton* bu = [cell.contentView viewWithKeyPath:name];
                
                [bu bindEvent:UIControlEventTouchUpInside withBlock:^{
                    NSString* message = [NSString stringWithFormat:_(@"kAlertViewMessage_UIControlBinding"),name];
                    CKAlertView* alert = [CKAlertView alertViewWithTitle:_(@"kAlertViewTitle_UIControlBinding") message:message];
                    [alert addButtonWithTitle:_(@"kOk") action:nil];
                    [alert show];
                }];
            }
            [cell endBindingsContext];
        }];
        [cells addObject:cell];
    }
    
    
    //ContentOffset
    {
        CKTableViewCellController* valueCell = [CKTableViewCellController cellControllerWithTitle:_(@"kTableContentOffset") action:nil];
        valueCell.cellStyle = CKTableViewCellStyleSubtitle2;
       
        [valueCell beginBindingsContextByRemovingPreviousBindings];
        
        //Here we bind on tableView.contentOffset property because the tableView doesn't exists yet.
        //It will get created in form's viewDidLoad method when the form gets displayed in a container controller.
        //By this way, we ensure that if the tableView or if the contentOffset of the tableView change, the detailText of the cell controller will get updated.
        
        [form bind:@"tableView.contentOffset" toObject:valueCell withKeyPath:@"detailText"];
        [valueCell endBindingsContext];
        
        [cells addObject:valueCell];
    }
    
    //Adding a section with the cell controllers
    [form addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:cells]]];
    
    //Binding the form title with the model's string property
    [form beginBindingsContextByRemovingPreviousBindings];
    [model bind:@"string" toObject:form withKeyPath:@"title"];
    [form endBindingsContext];
    
    return form;
}

@end
