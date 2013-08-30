//
//  CKStylesheetSampleViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleViewController.h"
#import "CKStylesheetSampleListViewController.h"
#import "CKStylesheetSampleTextViewController.h"
#import "CKStylesheetSampleProtocol.h"
#import <ResourceManager/ResourceManager.h>

@interface CKStylesheetSampleViewController ()

@end

@implementation CKStylesheetSampleViewController

- (void)postInit{
    [super postInit];
    [self setup]; 
}

- (void)setup{
    CKContainerViewController* rightContainer = [CKContainerViewController controller];
    CKStylesheetSampleTextViewController* text = [CKStylesheetSampleTextViewController controller];
    CKStylesheetSampleListViewController* list = [CKStylesheetSampleListViewController controller];
    
    self.viewControllers = @[list,
                             [CKViewController controllerWithName:@"Separator"],
                             text,
                             [CKViewController controllerWithName:@"Separator"],
                             rightContainer];
    
    __unsafe_unretained CKStylesheetSampleViewController* bself = self;
    
    list.didSelectSample = ^(id<CKStylesheetSampleProtocol> sample){
        CKViewController* controller = [sample newViewController];
        [rightContainer setViewControllers:@[controller]];
        [rightContainer presentViewControllerAtIndex:0 withTransition:CKTransitionNone];
        
        [bself updateTextViewController:text usingStylesheetFileName:[sample stylesheetFileName]];
    };
}
         
- (void)updateTextViewController:(CKStylesheetSampleTextViewController*)textViewController usingStylesheetFileName:(NSString*)filename{
    NSString* path = [RMResourceManager pathForResource:filename ofType:@"style"];
    
    NSError* error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    textViewController.content = content;
    
    [NSObject objectFromJSONData:[content dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    if(error){
        NSLog(@"StyleSheet at path '%@' contains error : %@",path,error);
    }
}

@end
