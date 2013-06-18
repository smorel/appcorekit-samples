//
//  CKStylesheetSampleListViewController.h
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKStylesheetSampleProtocol.h"

@interface CKStylesheetSampleListViewController : CKFormTableViewController
@property(nonatomic,copy)void(^didSelectSample)(id<CKStylesheetSampleProtocol> sample);
@end
