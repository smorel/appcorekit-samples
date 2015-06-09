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
        CKStandardContentViewController* cell = [CKStandardContentViewController controllerWithTitle:[url description] action:^(CKStandardContentViewController *controller) {
            if(bself.didSelectUrlBlock){
                bself.didSelectUrlBlock(url);
            }
        }];
        [cells addObject:cell];
    }
    
    //Configure the form
    self.stickySelectionEnabled = YES;
    [self addSections:@[ [CKSection sectionWithControllers:cells] ] animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Auto select the first url
    if(self.selectedIndexPaths.count > 0){
        [self.tableView selectRowAtIndexPath:self.selectedIndexPaths[0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        if(self.didSelectUrlBlock){
            self.didSelectUrlBlock([self.urls objectAtIndex:[self.selectedIndexPaths[0] row]]);
        }
    }
}

@end
