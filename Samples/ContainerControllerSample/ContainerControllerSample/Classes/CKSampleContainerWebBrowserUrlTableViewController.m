//
//  CKSampleContainerWebBrowserUrlTableViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerWebBrowserUrlTableViewController.h"

@interface CKSampleContainerWebBrowserUrlTableViewController()
@property(nonatomic,retain) NSArray* urls;
@end

@implementation CKSampleContainerWebBrowserUrlTableViewController


- (id)initWithUrls:(NSArray*)theUrls{
    self = [super init];
    self.urls = theUrls;
    [self setup];
    return self;
}

- (void)setup{
    
    //Create the cells for each url
    __unsafe_unretained CKSampleContainerWebBrowserUrlTableViewController* bself = self;
    NSMutableArray* cells = [NSMutableArray array];
    for(NSURL* url in self.urls){
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:[url description] action:^(CKTableViewCellController *controller) {
            if(bself.didSelectUrlBlock){
                bself.didSelectUrlBlock(url);
            }
        }];
        cell.value = url;
        [cells addObject:cell];
    }
    
    //Configure the form
    self.stickySelectionEnabled = YES;
    [self addSections:@[ [CKFormSection sectionWithCellControllers:cells] ]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Auto select the first url
    if(self.selectedIndexPath == nil){
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        
        if(self.didSelectUrlBlock){
            self.didSelectUrlBlock([self.urls objectAtIndex:0]);
        }
    }
}

@end
