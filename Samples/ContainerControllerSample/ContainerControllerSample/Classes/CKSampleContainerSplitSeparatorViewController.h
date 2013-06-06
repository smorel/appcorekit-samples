//
//  CKSampleContainerSplitSeparatorViewController.h
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKSampleContainerSplitSeparatorViewController : CKViewController
@property(nonatomic,copy) void(^didSelectShowHide)(BOOL show);
@end
