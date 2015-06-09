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
    
    CKReusableViewController* next = [self cellControllerForNextUser];
    CKReusableViewController* header  = [self cellControllerForHeader];
    CKReusableViewController* details = [self cellControllerForDetails];
    CKSection* section = [CKSection sectionWithControllers:@[next,header,details]];
    
    [self addSections:@[section] animated:NO];
    
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

- (CKReusableViewController*)cellControllerForHeader{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKReusableViewController* cellController = [CKReusableViewController controllerWithName:@"InstagramHeaderCell"];
    cellController.viewWillAppearBlock = ^(UIViewController* controller, BOOL animated){
        
        CKImageView* imageView = [controller.view  viewWithKeyPath:@"ImageHighlightBackgroundView.ImageLeft"];
        UILabel* photoCountLabel = [controller.view  viewWithKeyPath:@"PhotoCounterLabel"];
        UILabel* followersCounterLabel = [controller.view  viewWithKeyPath:@"FollowersCounterLabel"];
        UILabel* followingCounterLabel = [controller.view  viewWithKeyPath:@"FollowingCounterLabel"];
        UIButton* followButton = [controller.view  viewWithKeyPath:@"FollowButton"];
        
        [controller.view  beginBindingsContextByRemovingPreviousBindings];
        [bself.model bind:@"imageURL"          toObject:imageView             withKeyPath:@"imageURL"];
        [bself.model bind:@"numberOfPhotos"    toObject:photoCountLabel       withKeyPath:@"text"];
        [bself.model bind:@"numberOfFollowers" toObject:followersCounterLabel withKeyPath:@"text"];
        [bself.model bind:@"numberOfFollowing" toObject:followingCounterLabel withKeyPath:@"text"];
        [followButton bindEvent:UIControlEventTouchUpInside withBlock:^{
            [[UIApplication sharedApplication]openURL:bself.model.detailURL];
        }];
        [controller.view  endBindingsContext];
    };
    
    return cellController;
}

- (CKReusableViewController*)cellControllerForDetails{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKReusableViewController* cellController = [CKReusableViewController controllerWithName:@"InstagramDetailCell"];
    cellController.viewWillAppearBlock = ^(UIViewController* controller, BOOL animated){
        
        UILabel* headerLabel = [controller.view viewWithKeyPath:@"HeaderLabel"];
        UILabel* detailLabel = [controller.view viewWithKeyPath:@"DetailLabel"];
        UIButton* URLButton = [controller.view viewWithKeyPath:@"URLButton"];
        
        [controller.view beginBindingsContextByRemovingPreviousBindings];
        [bself.model bind:@"presentationText" toObject:headerLabel withKeyPath:@"text"];
        [bself.model bind:@"detailText" toObject:detailLabel withKeyPath:@"text"];
        [bself.model bind:@"detailURL" executeBlockImmediatly:YES withBlock:^(id value) {
            [URLButton setTitle:[bself.model.detailURL description] forState:UIControlStateNormal];
        }];
        [URLButton bindEvent:UIControlEventTouchUpInside withBlock:^{
            [[UIApplication sharedApplication]openURL:bself.model.detailURL];
        }];
        [controller.view endBindingsContext];
    };
    
    return cellController;
}

- (CKReusableViewController*)cellControllerForNextUser{
    __unsafe_unretained CKSampleLayoutInstagramViewController* bself = self;
    
    CKReusableViewController* cellController = [CKStandardContentViewController controllerWithTitle:_(@"Next") action:^(CKStandardContentViewController *controller) {
        controller.accessoryType = CKAccessoryActivityIndicator;
        [CKSampleLayoutInstagramDataSources fetchRandomUserInModel:bself.model completion:^{
            controller.accessoryType = CKAccessoryDisclosureIndicator;
         }];
    }];
    cellController.name = @"InstagramNextCell";
        
    return cellController;
}

@end
