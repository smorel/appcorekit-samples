//
//  FlowManager.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "FlowManager.h"
#import "FeedSourceFactory.h"
#import "ViewControllerFactory.h"

@implementation FlowManager

- (void)startInWindow:(UIWindow*)window{
    __block FlowManager* bSelf = self;
    
    CKArrayCollection* collection = [CKArrayCollection collectionWithFeedSource:[FeedSourceFactory feedSourceForModels]];
    CKViewController* controller = [ViewControllerFactory viewControllerForModels:collection modelSelectionBlock:^(Model *model) {
        [bSelf presentViewControllerForModel:model];
    }];
    controller.title = _(@"kModelsViewControllerTitle");
    
    //Sets controller left/right buttons for navigation if needed here ...
    
    UINavigationController* navigationController = [UINavigationController navigationControllerWithRootViewController:controller];
    window.rootViewController = navigationController;
}

- (void)presentViewControllerForModel:(Model*)model{
    //Implement this method if needed
}

@end
