//
//  CKStylesheetSampleProtocol.h
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKStylesheetSampleProtocol <NSObject>

- (CKViewController*)newViewController;
- (NSString*)stylesheetFileName;
- (NSString*)title;
- (NSString*)subtitle;

@end
