//
//  CKSampleContainerBreadCrumbViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerBreadCrumbViewController.h"

@implementation CKSampleContainerBreadCrumbViewController

//Here we create a form that will get displayed in the bread crumb
//This is a different way of creating a view controller not by derivation but by extending its behaviour using blocks
//sometimes it's shorter than creating a class specially for it especially if this is related to the current controller only !

- (CKFormTableViewController*)breadCrumbFormWithIndexSet:(NSIndexPath*)indexSet{
    BOOL stop = ([indexSet length] >=5);
    
    NSMutableArray* cells = [NSMutableArray array];
    for(int i=0; i<10; ++i){
        NSIndexPath* newIndexSet = [indexSet indexPathByAddingIndex:i];
        
        NSMutableString* title = [NSMutableString stringWithString:_(@"kBreadCrumbCellTitle")];
        
        if(newIndexSet){
            for(int j=0;j<[newIndexSet length]; ++j){
                [title appendFormat:@"_%d",[newIndexSet indexAtPosition:j]];
            }
        }
        
        __unsafe_unretained CKSampleContainerBreadCrumbViewController* bself = self;
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:title action:stop ? nil : ^(CKTableViewCellController* controller){
            CKFormTableViewController* newController = [bself breadCrumbFormWithIndexSet:newIndexSet];
            newController.title = title;
            [bself pushViewController:newController animated:YES];
        }];
        [cells addObject:cell];
    }
    
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"BreadCrumbForm"];
    [form addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:cells]]];
    return form;
}


- (void)postInit{
    [super postInit];
    [self setup];
}

- (void)setup{
    self.title = _(@"kBreadCrumbTitle");
    
    CKFormTableViewController* first = [self breadCrumbFormWithIndexSet:[NSIndexPath indexPathWithIndex:0]];
    first.title = _(@"kBreadCrumbFirstTitle");
    [self setViewControllers:@[first]];
}

@end
