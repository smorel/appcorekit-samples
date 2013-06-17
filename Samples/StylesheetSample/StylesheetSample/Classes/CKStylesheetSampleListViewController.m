//
//  CKStylesheetSampleListViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleListViewController.h"
#import "CKStylesheetSampleProtocol.h"

@interface CKStylesheetSampleListViewController ()

@end

@implementation CKStylesheetSampleListViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (NSArray*)sortedAndFilteredSampleClasses{
    NSArray* allClasses = [NSObject allClassesKindOfClass:[CKViewController class]];
    
    NSArray* filteredClasses = [allClasses filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject conformsToProtocol:@protocol(CKStylesheetSampleProtocol)];
    }]];
    
    NSArray* sortedAndFilteredClasses = [filteredClasses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 title]compare:[obj2 title]];
    }];
    
    return sortedAndFilteredClasses;
}

- (void)setup{
    self.style = UITableViewStylePlain;
    self.stickySelectionEnabled = YES;
    
    __unsafe_unretained CKStylesheetSampleListViewController* bself = self;
    
    NSMutableArray* cells = [NSMutableArray array];
    
    NSArray* sortedAndFilteredClasses = [self sortedAndFilteredSampleClasses];
    for(Class c in sortedAndFilteredClasses){
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:[c title] action:^(CKTableViewCellController *controller) {
            if(bself.didSelectSample){
                bself.didSelectSample([c stylesheetFileName],c);
            }
        }];
        [cells addObject:cell];
    }
    
    [self addSections:@[[CKFormSection sectionWithCellControllers:cells]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSIndexPath* firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self selectRowAtIndexPath:firstRow animated:NO];
    if(self.didSelectSample){
        CKTableViewCellController* cell = (CKTableViewCellController*)[self controllerAtIndexPath:firstRow];
        [cell didSelectRow];
    }
}

@end
