//
//  CKMapFormSynchronizationModel.h
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKMapFormSynchronizationModel : CKObject<MKAnnotation>
@property(nonatomic,assign) CGFloat longitude;
@property(nonatomic,assign) CGFloat latitude;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* phone;
@property(nonatomic,retain) NSString* identifier;
@end
