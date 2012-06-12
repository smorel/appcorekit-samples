//
//  ViewControllers.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllers.h"

@implementation ViewControllers

+ (CKUIViewController*)viewControllerForTimeline:(Timeline*)timeline{
    CKItemViewControllerFactory* tweetsFactory = [CKItemViewControllerFactory factory];
    [tweetsFactory addItemForObjectOfClass:[Tweet class] withControllerCreationBlock:^CKItemViewController *(id object, NSIndexPath *indexPath) {
        Tweet* tweet = (Tweet*)object;
        CKTableViewCellController* cellController =  [CKTableViewCellController cellControllerWithTitle:tweet.name subtitle:tweet.message defaultImage:[UIImage imageNamed:@"default_avatar"] imageURL:tweet.imageUrl imageSize:CGSizeMake(40,40) action:nil];
        [cellController setLayoutBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
            [controller performLayout];
            cell.imageView.frame = CGRectMake(controller.contentInsets.left,controller.contentInsets.top,40,40);
        }];
        return cellController;
    }];
    CKFormTableViewController* form = [CKFormTableViewController controller];
    form.name = @"Timeline";
    form.title = _(@"kTimelineTitle");
    
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:timeline.tweets factory:tweetsFactory appendCollectionCellControllerAsFooterCell:YES];
    [form addSections:[NSArray arrayWithObject:section]];
    return form;
}

@end
