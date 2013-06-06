//
//  CKSampleContainerSplitViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerSplitViewController.h"
#import "CKSampleContainerWebBrowserViewController.h"
#import "CKSampleContainerWebBrowserUrlTableViewController.h"
#import "CKSampleContainerSplitSeparatorViewController.h"

@implementation CKSampleContainerSplitViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (void)setup{
    self.title = _(@"kSplitterTitle");
    
    
    NSMutableArray* urls = [NSMutableArray arrayWithObjects:
                            [NSURL URLWithString:@"http://www.google.com"],
                            [NSURL URLWithString:@"http://www.stackoverflow.com"],
                            [NSURL URLWithString:@"http://www.github.com"],
                            nil];
    
    //Creates a web browser view controller
    CKSampleContainerWebBrowserViewController* browser = [CKSampleContainerWebBrowserViewController controller];
    CKSampleContainerWebBrowserUrlTableViewController* urlForm = [[CKSampleContainerWebBrowserUrlTableViewController alloc]initWithUrls:urls];
    CKSampleContainerSplitSeparatorViewController* splitter = [CKSampleContainerSplitSeparatorViewController controller];
    
    __unsafe_unretained CKSampleContainerWebBrowserViewController* bBrowser = browser;
    urlForm.didSelectUrlBlock = ^(NSURL* url){
        bBrowser.homeURL = url;
    };
    
    __unsafe_unretained CKSampleContainerSplitViewController* bself = self;
    __unsafe_unretained CKSampleContainerSplitSeparatorViewController* bSplitter = splitter;
    
    splitter.didSelectShowHide = ^(BOOL show){
        if(!show){
            [bself setViewControllersWithCustomAnimation:@[bSplitter, browser] ];
        }else{
            [bself setViewControllersWithCustomAnimation:@[urlForm, bSplitter, browser] ];
        }
    };
    
    self.viewControllers = @[urlForm, splitter, browser];
}

- (void)setViewControllersWithCustomAnimation:(NSArray*)viewControllers{
    [self setViewControllers:viewControllers
           animationDuration:.4
         startAnimationBlock:^(UIViewController *controller, CGRect beginFrame, CGRect endFrame, CKSplitViewControllerAnimationState state) {
             if(state == CKSplitViewControllerAnimationStateMoving){ controller.view.frame = beginFrame; }
             //else do not animate
         }
              animationBlock:^(UIViewController *controller, CGRect beginFrame, CGRect endFrame, CKSplitViewControllerAnimationState state) {
                  if(state == CKSplitViewControllerAnimationStateMoving){ controller.view.frame = endFrame; }
                  //else do not animate
              }
           endAnimationBlock:nil];
}


@end
