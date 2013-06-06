//
//  Document.h
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface Model : CKObject<MKAnnotation>
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* address;
@property(nonatomic,copy) NSString* phone;
@property(nonatomic,copy) NSURL* imageUrl;
@property(nonatomic,assign) CGFloat longitude;
@property(nonatomic,assign) CGFloat latitude;
@end