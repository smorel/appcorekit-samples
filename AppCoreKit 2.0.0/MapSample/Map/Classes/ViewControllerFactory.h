//
//  ViewControllerFactory.h
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "Document.h"

@interface ViewControllerFactory : NSObject

+ (CKViewController*)viewControllerForModels:(CKCollection*)models modelSelectionBlock:(void(^)(Model* model))modelSelectionBlock;

@end
