//
//  CKSampleContainerWebBrowserUrlTableViewController.h
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKSampleContainerWebBrowserUrlTableViewController : CKFormTableViewController
@property(nonatomic,copy) void(^didSelectUrlBlock)(NSURL* url);

- (id)initWithUrls:(NSArray*)urls;

@end
