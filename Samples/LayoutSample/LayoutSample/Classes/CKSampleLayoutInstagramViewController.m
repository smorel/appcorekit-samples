//
//  CKSampleLayoutInstagramViewController.m
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleLayoutInstagramViewController.h"
#import "CKSampleLayoutInstagramModel.h"
#import "CKSampleLayoutInstagramDataSources.h"
#import "CKSampleLayoutViewController.h"

@interface CKSampleLayoutInstagramViewController ()
@property(nonatomic,retain) CKSampleLayoutInstagramModel* model;
@end

@implementation CKSampleLayoutInstagramViewController

- (void)postInit{
    [super postInit];
    
    self.model = [CKSampleLayoutInstagramModel object];
    
    [self setup];
}

- (void)setup{
    self.title = _(@"Layout - Forms");
    
    CKTableViewCellController* next = [self cellControllerForNextUser];
    CKFormSection* nextSection = [CKFormSection sectionWithCellControllers:@[next]];
    
    CKTableViewCellController* header  = [self cellControllerForHeader];
    CKTableViewCellController* details = [self cellControllerForDetails];
    CKFormSection* modelSection = [CKFormSection sectionWithCellControllers:@[header,details]];
    
    [self addSections:@[nextSection, modelSection]];
    
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:_(@"View Controller") style:UIBarButtonItemStyleBordered block:^{
        CKSampleLayoutViewController* viewController = [CKSampleLayoutViewController controller];
        [bself.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [CKSampleLayoutInstagramDataSources fetchRandomUserInModel:self.model completion:nil];
}

- (CKTableViewCellController*)cellControllerForHeader{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithName:@"InstagramHeaderCell"];
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        
        CKImageView* imageView = [cell.contentView viewWithKeyPath:@"ImageHighlightBackgroundView.ImageLeft"];
        UILabel* photoCountLabel = [cell.contentView viewWithKeyPath:@"PhotoCounterLabel"];
        UILabel* followersCounterLabel = [cell.contentView viewWithKeyPath:@"FollowersCounterLabel"];
        UILabel* followingCounterLabel = [cell.contentView viewWithKeyPath:@"FollowingCounterLabel"];
        UIButton* followButton = [cell.contentView viewWithKeyPath:@"FollowButton"];
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        [bself.model bind:@"imageURL"          toObject:imageView             withKeyPath:@"imageURL"];
        [bself.model bind:@"numberOfPhotos"    toObject:photoCountLabel       withKeyPath:@"text"];
        [bself.model bind:@"numberOfFollowers" toObject:followersCounterLabel withKeyPath:@"text"];
        [bself.model bind:@"numberOfFollowing" toObject:followingCounterLabel withKeyPath:@"text"];
        [followButton bindEvent:UIControlEventTouchUpInside withBlock:^{
            [[UIApplication sharedApplication]openURL:bself.model.detailURL];
        }];
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (CKTableViewCellController*)cellControllerForDetails{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithName:@"InstagramDetailCell"];
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        
        UILabel* headerLabel = [cell.contentView viewWithKeyPath:@"HeaderLabel"];
        UILabel* detailLabel = [cell.contentView viewWithKeyPath:@"DetailLabel"];
        UIButton* URLButton = [cell.contentView viewWithKeyPath:@"URLButton"];
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        [bself.model bind:@"presentationText" toObject:headerLabel withKeyPath:@"text"];
        [bself.model bind:@"detailText" toObject:detailLabel withKeyPath:@"text"];
        [bself.model bind:@"detailURL" executeBlockImmediatly:YES withBlock:^(id value) {
            [URLButton setTitle:[bself.model.detailURL description] forState:UIControlStateNormal];
        }];
        [URLButton bindEvent:UIControlEventTouchUpInside withBlock:^{
            [[UIApplication sharedApplication]openURL:bself.model.detailURL];
        }];
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (CKTableViewCellController*)cellControllerForNextUser{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithTitle:_(@"Next") action:^(CKTableViewCellController *controller) {
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator startAnimating];
        
        controller.accessoryView = activityIndicator;
        [CKSampleLayoutInstagramDataSources fetchRandomUserInModel:bself.model completion:^{
            [controller performBlockOnMainThread:^{
                [activityIndicator stopAnimating];
                controller.accessoryView = nil;
                controller.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }];
         }];
    }];
    cellController.name = @"InstagramNextCell";
        
    return cellController;
}

@end
